using Microsoft.EntityFrameworkCore;
using co.app.api.Models;
using co.app.common;
using System.Net;

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

        public static string GetIPAddress()
        {
            IPHostEntry ipHostInfo = Dns.GetHostEntry(Dns.GetHostName()); // `Dns.Resolve()` method is deprecated.

            if (ipHostInfo.AddressList[1] != null)
            {
                IPAddress ipAddress = ipHostInfo.AddressList[1];

                return ipAddress.ToString();
            }
            else return "";

        }

        /*public static void UpdateExceptionLogInternally(
            ExceptionTypeEnum excType, AuditLogActivityEnum alaType, System.Exception systemExc,
            string ErrorMessage, string Source, string SourceURL, string Parameters, Guid? userId)
        {

            Guid? myGuidVar = null;

            ExceptionLog excLog = new ExceptionLog();

            excLog.ExceptionTypeId = excType;
            excLog.AuditLogActivityId = alaType;
            excLog.SystemException = systemExc;
            excLog.Detail = ErrorMessage;
            excLog.ServerName = Environment.MachineName;
            excLog.Source = Source;
            excLog.SourceURL = String.Format("{0}/api/emrData/{1}", GetIPAddress(), SourceURL);
            excLog.Parameters = Parameters;
            excLog.UserId = (userId.HasValue ? userId.Value : myGuidVar);

            //LoginException.UpdateExceptionLogging(excLog);
        } */
    }
}
