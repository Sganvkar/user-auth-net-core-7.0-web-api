using co.app.api.Filters;
using co.app.api.Models;
using co.app.common;
using co.app.common.WebApi;
using co.app.common.WebApi.UserAttribute.Get;
using co.app.common.WebApi.UserAttribute.Upsert;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace mss.api.Controllers
{
    [ServiceFilter(typeof(TokenAuthorizationFilter))]
    [Route("api/[controller]")]
    public class UserAttributeController : ControllerBase
    {
        private readonly MainContext _context;

        public UserAttributeController(MainContext context)
        {
            _context = context;
        }

        [HttpPost]
        [Route("UpsertUserAttribute")]
        public ResponseModel UpsertUserAttribute([FromBody] UserAttributeRequestModel requestModel)
        {

            try
            {

                var responseModel = new ResponseModel();

                if (requestModel == null)
                {
                    responseModel.IsError = true;
                    responseModel.ErrorId = 1;
                    responseModel.ErrorMessage = "User Attribute Data is null, please check your request";
                    responseModel.ValidateResponse = "User Attribute object is empty";
                    return responseModel;
                }

                var result = _context.GetResponseWithGuid.FromSqlRaw(Constants.app_SP_UpsertUserAttribute,
                    requestModel.UserAttributeId, requestModel.UserAttributeName, requestModel.UserAttributeDescription,
                    requestModel.AttributeId, requestModel.CreatedById, requestModel.CrudIds).ToList()[0];

                return new ResponseModel
                {
                    IsError = false,
                    ErrorId = 0,
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
                    ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message.ToString())
                };
            }
        }


        [HttpGet]
        [Route("GetUserAttrributes")]
        public ResponseModelWith<UserAttribute> GetUserAttrributes()
        {
            try
            {
                var arrayOfItems = _context.UserAttributes.FromSqlRaw(
                              Constants.app_SP_GetUserAttributes).ToList();

                return new ResponseModelWith<UserAttribute>
                {
                    IsError = false,
                    ErrorMessage = "",
                    ValidateResponse = "Your Operation Is Done.",
                    arrayOfItems = arrayOfItems
                };
            }
            catch (Exception ex)
            {
                return new ResponseModelWith<UserAttribute> { IsError = true, ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), arrayOfItems = null };

            }

        }

        [HttpPost]
        [Route("DeleteUserAttribute")]
        public ResponseModel DeleteUserAttribute([FromBody] UserAttributeRequestModel requestModel)
        {

            try
            {

                var responseModel = new ResponseModel();

                if (requestModel == null || requestModel.UserAttributeId == null)
                {
                    responseModel.IsError = true;
                    responseModel.ErrorId = 1;
                    responseModel.ErrorMessage = "User Attribute Id is null, please check your request";
                    responseModel.ValidateResponse = "User Attribute Id is not valid";

                    return responseModel;
                }
                var result = _context.GetResponseWithGuid.FromSqlRaw(
                    Constants.app_SP_DeleteUserAttribute,
                   requestModel.UserAttributeId, requestModel.CreatedById).ToList()[0];


                return new ResponseModel
                {
                    IsError = false,
                    ErrorId = 0,
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
    }
}
