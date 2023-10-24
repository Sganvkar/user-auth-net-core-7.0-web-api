using co.app.api.Filters;
using co.app.api.Models;
using co.app.common;
using co.app.common.WebApi;
using co.app.common.WebApi.Role;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace mss.api.Controllers
{
    [ServiceFilter(typeof(TokenAuthorizationFilter))]
    [Route("api/[controller]")]
    public class RoleController : Controller
    {
        private readonly MainContext _context;
        public RoleController(MainContext context)
        {
            _context = context;
        }

        [HttpPost("upsert-role")]
        public ResponseModel UpsertRole([FromBody] RoleRequestModel role)
        {
            try
            {
                var result = _context.GetResponseWithNoDataReturn.FromSqlRaw(Constants.app_SP_UpsertRole,
                    role.RoleId, role.RoleName, role.RoleDescription,role.UserGUID, role.CopiedRoleId
                ).ToList()[0];

                return new ResponseModel
                {
                    IsError = result.IsError,
                    ErrorId = result.ErrorId,
                    ErrorMessage = result.ErrorMessage,
                    ValidateResponse = result.ValidateResponse
                };

            }
            catch (Exception ex)
            {
                return new ResponseModel
                {
                    IsError = true,
                    ErrorId = 1,
                    ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message.ToString()),
                    ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message.ToString()),
                };

            }
        }


        [HttpGet]
        [Route("get-roles")]
        public ResponseModelWith<Role> GetRole([FromQuery] Guid AccessById)
        {
            try
            {
                var arrayOfItems = _context.RoleModels.FromSqlRaw(Constants.app_SP_GetAllRoles, AccessById).ToList();

                return new ResponseModelWith<Role>
                {
                    IsError = false,
                    ErrorMessage = "",
                    ValidateResponse = "Your Operation Is Done.",
                    arrayOfItems = arrayOfItems
                };

            }
            catch (Exception ex)
            {

                return new ResponseModelWith<Role> { IsError = true, ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), arrayOfItems = null };
            }


        }


        [HttpDelete]
        [Route("delete-role")]
        public ResponseModel DeleteRole([FromBody] RoleRequestModel requestModel)
        {

            try
            {

                var responseModel = new ResponseModel();

                if (requestModel == null)
                {
                    responseModel.IsError = true;
                    responseModel.ErrorId = 1;
                    responseModel.ErrorMessage = "Role Id is null, please check your request";
                    responseModel.ValidateResponse = "Role Id is not valid";

                    return responseModel;
                }

                var result = _context.GetResponseWithNoDataReturn.FromSqlRaw(Constants.app_SP_DeleteRole, requestModel.RoleId, requestModel.UserGUID).ToList()[0];

                return new ResponseModel
                {
                    IsError = false,
                    ErrorMessage = result.ErrorMessage,
                    ValidateResponse = result.ValidateResponse,
                };
            }
            catch (Exception ex)
            {

                return new ResponseModel
                {
                    IsError = true,
                    ErrorId = 1,
                    ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message.ToString()),
                    ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message.ToString()),
                };
            }

        }
    }
}
