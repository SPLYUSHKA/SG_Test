using SGTest.DataImporter;
using SGTest.Models;
using System.Text.RegularExpressions;

internal class Program
{
    private static void Main(string[] args)
    {
        const string filenameSymbols = @"a-zA-Z0-9._\/\\:";
        while (true)
        {
            string input = Console.ReadLine()?.Trim() ?? string.Empty;

            if (input == "exit")
            {
             
                break;
            }
            else if (Regex.IsMatch(input, @$"^import\s+([{filenameSymbols}]+)\s+(dep|emp|job)$"))
            {
                var match = Regex.Match(input, @$"^import\s+([{filenameSymbols}]+)\s+(dep|emp|job)$");
                string filename = match.Groups[1].Value;
                string importType = match.Groups[2].Value;
                import(filename, importType);
            }
            else if (Regex.IsMatch(input, @"^output\s*[0-9]*$"))
            {
                var match = Regex.Match(input, @"^output\s*([0-9]*)$");
                string inputId = match.Groups[1].Value;
                if (inputId == string.Empty)
                {
                    fullOutput();
                }
                else if (int.TryParse(match.Groups[1].Value, out int id))
                {
                    output(id);
                }
                else
                {
                    Console.Error.WriteLine("Неверный формат ввода целого числа");
                }
            }
            else if (input == "help")
            {
                Console.WriteLine("Импорт данных:\n>> import <FILENAME> (dep|emp|job)");
                Console.WriteLine("Вывод информации по отделу:\n>> output\n>> output ID");
                Console.WriteLine("Получение справки:\n>> help");
                Console.WriteLine("Выход из программы:\n>> exit");
            }
            else
            {
                Console.WriteLine("Несуществующая команда или неправильный синтаксис команды, введите help для получения информации");
            }
        }



        /// <summary>
        /// Обрабатывает и вносит данные в БД.
        /// <param name="filename">Имя/путь до файла</param>
        /// <param name="inputType">Тип данных для импорта(department/jobTitle/employee)</param>
        ///</summary>
        void import(string filename, string importType)
        {
            if (!File.Exists(filename))
            {
                Console.Error.WriteLine($"Файл {filename} не найден!");
                return;
            }

            using (StreamReader reader = new(filename))
            using (SgtestDatabaseContext context = new())
            {
                if (importType == "dep")
                {
                    var departmentsImporter = new DepartmentsImporter(context, reader);
                    int total = departmentsImporter.Import();
                    Console.WriteLine($"Всего затронуто {total} записей");
                }
                else if (importType == "job")
                {
                    var jobImporter = new JobTitlesImporter(context, reader);
                    int total = jobImporter.Import();
                    Console.WriteLine($"Всего затронуто {total} записей");
                }
                else if (importType == "emp")
                {
                    var employeeImporter = new EmployeesImporter(context, reader);
                    int total = employeeImporter.Import();
                    Console.WriteLine($"Всего затронуто {total} записей");
                }
            }
        }
        /// <summary>
        /// Выводит информацию о подразделениях из базы данных по алфавиту с соблюдением иерархии.
        /// <param name="departments">Лист подразделений</param>
        /// <param name="context">Экземпляр контекста</param>
        /// <param name="level">Уровень иерархии</param>
        ///</summary>
        void printAllDepartments(List<Department> departments, SgtestDatabaseContext context, int level)
        {
            if (departments.Count == 0)
            {
                return;
            }
            foreach (Department department in departments.OrderBy(d => d.Name))
            {
                context.Entry(department).Collection(d => d.InverseParent).Load();
                printDepartment(department, context, level);
                printAllDepartments(department.InverseParent.ToList(), context, level + 1);
            }
        }
        /// <summary>
        /// Вывод информации о подразделении и его сотрудниках 
        /// <param name="department">Подразделение</param>
        /// <param name="context">Экземпляр контекста</param>
        /// <param name="level">уровень вложенности в иерархии</param>
        ///</summary>
        void printDepartment(Department department, SgtestDatabaseContext context, int level)
        {
            context.Entry(department).Collection(d => d.Employees).Load();
            Console.WriteLine("{0} {1} ID={2}", new string('=', level), department.Name, department.Id);
            foreach (Employee employee in department.Employees)
            {
                context.Entry(employee).Reference(e => e.JobTitleNavigation).Load();
                string label = new string(' ', level) + (department.ManagerId == employee.Id ? "*" : " - ");
                Console.WriteLine(
                    "{0}{1} {2} ID={3} ({4} ID={5})",
                    new string(' ', level),
                    department.ManagerId == employee.Id ? "*" : "-",
                    employee.FullName,
                    employee.Id,
                    employee.JobTitleNavigation.Name,
                    employee.JobTitleNavigation.Id
                );
            }
        }
        
        void fullOutput()
        {
            using (SgtestDatabaseContext context = new())
            {
                printAllDepartments(context.Departments.Where(d => d.ParentId == null).ToList(), context, 1);
            }
        }
    
        void output(int departmentId)
        {
            using (SgtestDatabaseContext context = new())
            {
                var department = context.Departments.Find(departmentId);
                if (department is null)
                {
                    Console.Error.WriteLine($"Подразделение {departmentId} не найдено!");
                }
                else
                {
                    printDepartmentLine(department, context);
                }
            }
        }
        /// <summary>
        /// Вывод информации о подразделении в том случае, когда пользователь ввёл его id 
        /// <param name="department">Подразделение</param>
        /// <param name="context">Экземпляр контекста</param>
        ///</summary>
        void printDepartmentLine(Department department, SgtestDatabaseContext context)
        {
            Department? current = department;
            Stack<Department> result = new Stack<Department>();

            while (current != null)
            {
                context.Entry(current).Reference(d => d.Parent).Load();
                result.Push(current);
                current = current.Parent;
            }

            int level = 1;
            while (result.Count > 1)
            {
                current = result.Pop();
                Console.WriteLine("{0} {1} ID={2}", new string('=', level), current.Name, current.Id);
                level++;
            }

            printDepartment(department, context, level);
        }

    }
       

}
