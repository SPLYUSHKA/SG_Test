using Microsoft.EntityFrameworkCore;
using SGTest.Errors;
using SGTest.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace SGTest.DataImporter
{
    internal class EmployeesImporter : DataImporter<Employee>
    {
        public EmployeesImporter(SgtestDatabaseContext context, StreamReader reader) : base(context, reader)
        {
            context.Departments.Load();
            context.JobTitles.Load();
        }

        protected override Employee? FindDublicate(Employee instance) =>
                    context.Employees
                        .FirstOrDefault(employee => employee.FullName.ToLower() == instance.FullName.ToLower()) ??
                    context.Employees
                        .Local
                        .FirstOrDefault(employee => employee.FullName.ToLower() == instance.FullName.ToLower());

        protected override Employee Parse(string csvLine)
        {
            csvLine = Regex.Replace(csvLine, @" {2,}", " ");
            string[] columns = csvLine.Split('\t', StringSplitOptions.TrimEntries);

            if (columns.Length != 5 || columns.Any(col => string.IsNullOrWhiteSpace(col)))
            {
                throw new ParseLineException("Количество столбцов не равно 5 или один из столбцов оказался пустым");
            }
            Department? department = context
               .Departments
               .Local
               .FirstOrDefault(d => d.Name.ToLower() == columns[0].ToLower());

            if (department is null)
            {
                throw new ParseLineException($"Отдел `{columns[0]}` не найден!");
            }
            JobTitle? job = context
                .JobTitles
                .Local
                .FirstOrDefault(j => j.Name.ToLower() == columns[4].ToLower());

            if (job is null)
            {
                throw new ParseLineException($"Должность `{columns[4]}` не найдена!");
            }

            return new Employee
            {
                DepartmentNavigation  = department,
                FullName = columns[1],
                Login = columns[2],
                Password = columns[3],
                JobTitleNavigation = job
            };

        }

        protected override void ProceedDublicate(Employee dublicate, Employee currentRecord)
        {
            if (currentRecord.DepartmentNavigation is not null)
            {
                currentRecord.Department = currentRecord.DepartmentNavigation.Id;
            }

            if (currentRecord.JobTitleNavigation is not null)
            {
                currentRecord.JobTitle = currentRecord.JobTitleNavigation.Id;
            }

            dublicate.FullName = currentRecord.FullName;
            dublicate.Login = currentRecord.Login;
            dublicate.Password = currentRecord.Password;
            dublicate.Department = currentRecord.Department;
            dublicate.JobTitle = currentRecord.JobTitle;
        }
    }
}
