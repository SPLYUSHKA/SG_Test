using SGTest.Errors;
using SGTest.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGTest.DataImporter
{
    internal class JobTitlesImporter : DataImporter<JobTitle>
    {
        public JobTitlesImporter(SgtestDatabaseContext context, StreamReader reader) : base(context, reader)
        {
        }

        protected override JobTitle? FindDublicate(JobTitle instance) =>
              context.JobTitles.FirstOrDefault(jt => jt.Name.ToLower() == instance.Name.ToLower()) ??
              context.JobTitles.Local.FirstOrDefault(jt => jt.Name.ToLower() == instance.Name.ToLower());



        protected override JobTitle Parse(string csvLine)
        {
            if (string.IsNullOrWhiteSpace(csvLine))
            {
                throw new ParseLineException($"Название должности не может быть пустым");
            }

            return new JobTitle { Name = csvLine.Trim() };
        }

        protected override void ProceedDublicate(JobTitle dublicate, JobTitle currentRecord)
        {
            Console.Error.WriteLine($"Запись `{dublicate.Name}` уже существует");
        }
    }
}
