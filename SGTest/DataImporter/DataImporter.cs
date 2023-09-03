using SGTest.Errors;
using SGTest.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGTest.DataImporter
{
    /// <summary>
    /// Класс реализует шаблонный метод, определяющий скелет алгоритма для обработки данных
    /// (поиска дубликатов/работы с найдеными дубликатами/парсинга данных).
    /// Принимает тип с которым будет работать(dep/job/emp)
    ///</summary>
    public abstract class DataImporter<T>
    {
        protected readonly SgtestDatabaseContext context;
        protected readonly StreamReader reader;
        //может быть использовано для выполнения SaveChanges на каждой итерации
        protected bool saveEveryIteration = false;


        public DataImporter(SgtestDatabaseContext context, StreamReader reader)
        {
            this.context = context;
            this.reader = reader;
        }
        
        protected abstract T Parse(string csvLine);
        protected abstract T? FindDublicate(T instance);
        protected abstract void ProceedDublicate(T dublicate, T currentRecord);

   
        private int saveContextChanges()
        {
            try
            {
                return context.SaveChanges();
            }
            catch (Exception err)
            {
                Console.Error.WriteLine($"Ошибка при сохранении: `{err.Message}`");
                return 0;
            }
        }

      
        public int Import()
        {
            string? line;
            int total = 0;

            reader.ReadLine();
            while ((line = reader.ReadLine()) is not null)
            {
                T instance = default!;
                try
                {
                    instance = Parse(line);
                }
                catch (ParseLineException err)
                {
                    Console.Error.WriteLine($"Произошла ошибка преобразования записи `{line}`: {err.Message}");
                    continue;
                }

                T? dublicate = FindDublicate(instance);

                if (dublicate is null)
                {
                    context.Add(instance!);
                }
                else
                {
                    ProceedDublicate(dublicate, instance);
                }

                if (saveEveryIteration)
                {
                    total += saveContextChanges();
                }
            }

            if (!saveEveryIteration)
            {
                total = saveContextChanges();
            }

            return total;
        }
    }
}
