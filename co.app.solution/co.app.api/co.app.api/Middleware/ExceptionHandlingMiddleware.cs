using Newtonsoft.Json;
using System.Net;
using System.Reflection;
using System.Text;
using Microsoft.EntityFrameworkCore;
using co.app.api.Models;
using co.app.common;

namespace mss.api.Middleware
{
    public class ExceptionHandlingMiddleware
    {

        public RequestDelegate requestDelegate;
        public ExceptionHandlingMiddleware(RequestDelegate requestDelegate)
        {
            this.requestDelegate = requestDelegate;
        }

        public async Task Invoke(HttpContext context, ILogger<ExceptionHandlingMiddleware> logger)
        {
            try
            {
                await requestDelegate(context);
            }
            catch (Exception ex)
            {
                await this.HandleException(context, ex, logger);
            }
        }

        private async static Task<string> ReadStringDataManual(HttpContext context)
        {
            using StreamReader reader = new StreamReader(context.Request.Body, Encoding.UTF8);
            return await reader.ReadToEndAsync();
        }

        private async Task<Task> HandleException(HttpContext context, Exception ex, ILogger<ExceptionHandlingMiddleware> logger)
        {
            string UserGUID = null;
            string ClientIP = "N/A";
            string UserName = "N/A";
            try
            {
                Task<string> requestBody = ReadStringDataManual(context);
                var queryString = Microsoft.AspNetCore.WebUtilities.QueryHelpers.ParseQuery(requestBody.Result);
                UserGUID = queryString["UserGUID"];
                UserName = queryString["UserName"];
                ClientIP = queryString["ClientIP"];
            }
            catch (Exception ee)
            {
                Console.WriteLine(ee.Message);

            }
            //logger.LogError(ex.ToString());
            string ClassName = "N/A";
            string MethodName = "N/A";
            string Message = ex.Message;
            string Code = "GE";
            MethodBase mb = ex.TargetSite;
            if (mb != null)
            {
                ClassName = ex.TargetSite.DeclaringType.FullName;
                MethodName = ex.TargetSite.Name;
            }

            ExceptionModel exModel = new ExceptionModel
            {
                ClassName = ClassName,
                MethodName = MethodName,
                Message = Message,
                Code = Code,
                UserGUID = UserGUID,
                UserName = UserName,
                ClientIP = ClientIP,
                ClientComputerName = "Computer Name"
            };
            var errorMessage = JsonConvert.SerializeObject(exModel);

            context.Response.ContentType = "application/json";
            context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
            try
            {
                await LogExceptionToDB(exModel);
            }
            catch (Exception ee)
            {
                Console.WriteLine(ee.Message);
            }
            return context.Response.WriteAsync(errorMessage);
        }

        private Task LogExceptionToDB(ExceptionModel exModel)
        {
            try
            {
                LoggingContext _contextLogging = APIUtility.GetLoggingContext();
                exModel.ClientComputerName = "Computer Name";
                var arrayOfItems = _contextLogging.StandardResponseModel.FromSqlRaw(
                                    Constants.app_SP_UpdateExceptionlog,
                                    exModel.ClassName,
                                    exModel.MethodName,
                                    exModel.Message,
                                    exModel.Code,
                                    exModel.UserGUID,
                                    exModel.UserName,
                                    exModel.ClientIP,
                                    exModel.ClientComputerName
                                    ).ToList()[0];
            }
            catch (Exception ee)
            {
                Console.WriteLine(ee.Message);
                LogExceptionToFile(ee);
            }
            return null;
        }

        private Task LogExceptionToFile(Exception ex)
        {
            string logFilePath = "path_to_your_log_file.txt"; // Set the path to your log file

            // Format the exception message and details
            string logMessage = $"Exception: {ex.GetType().FullName}{Environment.NewLine}" +
                               $"Message: {ex.Message}{Environment.NewLine}" +
                               $"Stack Trace: {ex.StackTrace}{Environment.NewLine}" +
                               $"Timestamp: {DateTime.Now}{Environment.NewLine}";

            // Write the exception details to the log file
            File.AppendAllText(logFilePath, logMessage);
            return null;
        }
    }
}
