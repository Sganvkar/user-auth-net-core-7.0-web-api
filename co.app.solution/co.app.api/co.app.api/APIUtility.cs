using Microsoft.EntityFrameworkCore;
using co.app.api.Models;
using co.app.common;

namespace mss.api
{
    public class APIUtility
    {
        public static LoggingContext GetLoggingContext()
        {
            DbContextOptionsBuilder<LoggingContext> optionsBuilder =
                new DbContextOptionsBuilder<LoggingContext>();
            optionsBuilder.UseSqlServer(Helper.GetLoggingConnectionString);

            return new LoggingContext(optionsBuilder.Options);
        }
    }
}
