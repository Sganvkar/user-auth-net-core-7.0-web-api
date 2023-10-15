using co.app.api.Filters;
using co.app.api.Models;
using co.app.common;
using co.app.common.WebApi;
using co.app.common.WebApi.UserAuditLog.Create;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace mss.api.Controllers
{
    [ServiceFilter(typeof(ApiAuthorizationFilter))]
    [Route("api/[controller]")]
    public class AuditLogController : Controller
    {
        private readonly co.app.api.Models.MainContext _context;
        private readonly LoggingContext _contextLogging;

        public AuditLogController(LoggingContext contextLogging, co.app.api.Models.MainContext context)
        {
            _context = context;
            _contextLogging = contextLogging;
        }


        [HttpPost]
        [Route("LogUserBehaviour")]
        public ResponseModel LogUserBehaviour([FromBody] CreateUserBehaviourLogRequestModel requestModel)
        {
            try
            {

            if (requestModel == null)
            {
                return new ResponseModel() { IsError = true, ErrorId = 1, ErrorMessage = "Audit Logging error. Invalid request object!", ValidateResponse = "Audit Logging error. Invalid request object!" };
            }

            var rip = HttpContext.Connection.RemoteIpAddress == System.Net.IPAddress.None ? "::1" : HttpContext.Connection.RemoteIpAddress.ToString();
            if (rip.ToLower() != "::1" && rip.ToLower() != "localhost")
            {
                requestModel.ClientIP = rip;
            }
            requestModel.ClientComputerName = "Computer Name";

            var arrayOfItems = _contextLogging.StandardResponseModel.FromSqlRaw(
                                Constants.app_SP_UpdateUserAuditLog,
                                requestModel.AuditLogObjectName,
                                requestModel.ClientComputerName,
                                requestModel.ObjectGUID,
                                requestModel.ShortDescription,
                                requestModel.Details,
                                requestModel.ObjectID,
                                requestModel.UserName,
                                requestModel.UserGUID,
                                requestModel.ClientIP
                                ).ToList()[0];
            return new ResponseModel() { IsError = false, ErrorId = -1, ErrorMessage = "", ValidateResponse = "Audit Logging..." };
            }
            catch (Exception ex)
            {
                return new ResponseModel() { IsError = true, ErrorId = -1
                    , ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message)
                    , ValidateResponse = "Error while Audit Logging." };
            }
        }


    }
}
