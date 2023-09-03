using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SGTest.Errors
{
    public class ParseLineException : Exception
    {
        public ParseLineException(string message) : base(message)
        {

        }

    }
}
