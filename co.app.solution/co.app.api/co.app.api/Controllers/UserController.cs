using co.app.api.Filters;
using co.app.api.Models;
using co.app.common;
using co.app.common.WebApi;
using co.app.common.WebApi.Common;
using co.app.common.WebApi.User.Upsert;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace mss.api.Controllers
{
    [ServiceFilter(typeof(TokenAuthorizationFilter))]
    [Route("api/[controller]")]
    public class UserController : ControllerBase
    {   
        private readonly MainContext _context;
        public UserController(MainContext context)
        {
            _context = context;
        }

        [HttpPost]
        [Route("UpsertUser")]
        public ResponseModel UpsertUser([FromForm] UserRequestModel userModel)
        {
            try
            {

                var userPhotoData = new MemoryStream();
                byte[] userPhotofile = null;

                if (userModel.UserPhoto != null)
                {
                    userModel.UserPhoto.CopyTo(userPhotoData);

                    userPhotofile = userPhotoData.ToArray();
                }
                else
                {
                    userPhotofile = userModel.MugShot;
                }

                var result = _context.GetResponseWithNoDataReturn.FromSqlRaw(
                    Constants.app_SP_UpsertUser, userModel.UserId,
                    userModel.UserName, userModel.Password, userModel.ClientIP
                    ,userModel.FirstName, userModel.LastName, userModel.JobTitle, userModel.Location,
                    (userPhotofile == null ? new byte[] { } : userPhotofile),
                    userModel.RoleIds, userModel.DefaultAttributeIds, userModel.IsUserLocked, userModel.IsActive
                    , userModel.UserGUID).ToList()[0];

                return new ResponseModel { IsError = false, ErrorMessage = result.ErrorMessage , ValidateResponse = result.ValidateResponse };
            }
            catch (Exception ex)
            {
                return new ResponseModel { IsError = true, ErrorId = 1, ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message)};
            }
        }


        [HttpGet]
        [Route("GetAllUsers")]
        public ResponseModelWith<UserModel> GetAllUsers([FromBody] Guid UserId)
        {
            try
            {
                var arrayOfItems = _context.Users.FromSqlRaw(Constants.app_SP_GetAllUsers, UserId).ToList();

                foreach (UserModel userModel in arrayOfItems)
                {
                    if (userModel.MugShot != null)
                        userModel.MugShotImage = System.Convert.ToBase64String(userModel.MugShot);
                }

                return new ResponseModelWith<UserModel>
                {
                    IsError = false,
                    ErrorMessage = "",
                    ValidateResponse = "Your Operation Is Done.",
                    arrayOfItems = arrayOfItems
                };
            }
            catch (Exception ex)
            {
                return new ResponseModelWith<UserModel> { IsError = true, ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), arrayOfItems = null };
            }




        }

        [HttpDelete()]
        [Route("DeleteUser")]
        public ResponseModel DeleteUser([FromBody] DeleteRequestModel requestModel)
        {

            try
            {

                var responseModel = new ResponseModel();

                if (requestModel == null)
                {
                    responseModel.IsError = true;
                    responseModel.ErrorId = 1;
                    responseModel.ErrorMessage = "Please check your request";
                    responseModel.ValidateResponse = "Invalid";

                    return responseModel;
                }

                var result = _context.GetResponseWithGuid.FromSqlRaw(
                    Constants.app_SP_DeleteUser,
                   requestModel.Id, requestModel.DeletedById).ToList()[0];

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
    }
}
