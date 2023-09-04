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
    internal class DepartmentsImporter : DataImporter<Department>
    {
        public DepartmentsImporter(SgtestDatabaseContext context, StreamReader reader) : base(context, reader)
        {
            saveEveryIteration = true;
        }

        protected override Department? FindDublicate(Department instance)
        {
            if (instance.Parent is not null)
            {
                instance.ParentId = instance.Parent.Id;
            }
            //Для того, чтобы избежать добавления дубликатов в случае,
            //когда они уже имеются в файле для импорта ,
            //проверка сделана и для локальной таблицы.
            return context
                .Departments
                .FirstOrDefault(d => d.Name.ToLower() == instance.Name.ToLower() && d.ParentId == instance.ParentId) ??
                context
                .Departments
                .Local
               .FirstOrDefault(d => d.Name.ToLower() == instance.Name.ToLower() && d.ParentId == instance.ParentId);

        }

        private Department? findDepartmentByName(string name) =>
            context.Departments.FirstOrDefault(d => d.Name.ToLower() == name.ToLower());

        private Employee? findEmployeeByFullname(string fullname) =>
            context.Employees.FirstOrDefault(e => e.FullName.ToLower() == fullname.ToLower());

        protected override Department Parse(string csvLine)
        {
            csvLine = Regex.Replace(csvLine, @" {2,}", " ");
            string[] columns = csvLine.Split('\t', StringSplitOptions.TrimEntries);
            if (columns.Length != 4)
            {
                throw new ParseLineException("Количество колонок не равно 4");
            }
            if (columns[0] == string.Empty)
            {
                throw new ParseLineException("Название отдела не может быть пустым");
            }

            
            Department? foundDepartment = findDepartmentByName(columns[1]);
            if (foundDepartment is null && columns[1] != string.Empty)
            {
                throw new ParseLineException($"Отдел `{columns[1]}` не найден");
            }
            Department? parent = foundDepartment;

            Employee? foundEmployee = findEmployeeByFullname(columns[2]);
           /* if (foundEmployee is null && columns[2] != string.Empty)
            {
                
                //throw new ParseLineException($"Сотрудник `{columns[2]}` не найден");
            }*/
            Employee? manager = foundEmployee;
            if (columns[3] == string.Empty)
            {
                throw new ParseLineException($"Номер телефона не может быть пустым!");
            }

            return new Department
            {
                Name = columns[0],
                Parent = parent,
                Manager = manager,
                Phone = columns[3]
            };
        }

        protected override void ProceedDublicate(Department dublicate, Department current)
        {
            if (current.Manager is not null)
            {
                current.ManagerId = current.Manager.Id;
            }

            dublicate.ManagerId = current.ManagerId;
        }
    }
}
