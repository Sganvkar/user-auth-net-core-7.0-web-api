using co.app.api.JWTFeatures;
using co.app.api.Models;
using co.app.common;
using co.app.common.WebApi;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Text.Json;

namespace mss.api.Controllers
{
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly MainContext _context;
        private readonly JWTHandler _jwtHandler;
        public AuthController(MainContext context, JWTHandler jwtHandler)
        {
            _context = context;
            _jwtHandler = jwtHandler;
        }


        [HttpPost]
        [Route("validate-user")]
        public AuthResponseModel ValidateUser([FromBody] LoginRequestModel requestBody)
        {
            try
            {
                var username = Helper.DecryptValue(requestBody.Username);
                var password = Helper.DecryptValue(requestBody.Password);

                var clientIp = Helper.GetClientIP;

                var checkUserResult = _context.UserCheckResponseModel.FromSqlRaw(Constants.app_SP_CheckUser, username, clientIp).ToList()[0];

                if (checkUserResult.IsValidUser)
                {

                    var passwordFromDb = Helper.DecryptValue(checkUserResult.Password);
                    if (passwordFromDb == password)
                    {
                        var userDetails = _context.UserDetailsModel.FromSqlRaw(Constants.app_SP_GetUserDetails, username, clientIp).ToList()[0];

                        TokenModel jwtToken = GetToken(userDetails);

                        TokenModel tokenResult = _context.TokenModel.FromSqlRaw(
                           Constants.app_SP_CreateTokenInDB, userDetails.UserName, jwtToken.CurrentToken, jwtToken.CurrentToken,
                           jwtToken.TokenValidFrom.Value, jwtToken.TokenValidTo.Value, jwtToken.ClientID).ToList()[0];

                        userDetails.TokenID = tokenResult.ID;
                        userDetails.Token = jwtToken.CurrentToken;
                        userDetails.RefreshToken = jwtToken.RotativeToken;
                        userDetails.IsError = false;
                        userDetails.ErrorMessage = "";
                        userDetails.ValidateResponse = "";


                        return new AuthResponseModel { IsAuthSuccessful = true, User = userDetails, ErrorMessage = "" };
                    }
                    else
                    {

                        var userResult = _context.GetResponseWithNoDataReturn
                            .FromSqlRaw(
                            Constants.app_SP_UpdateUserLoginStatus, checkUserResult.UserId, Constants.maxUnsuccessfullLoginAttempts).ToList()[0];


                        return new AuthResponseModel
                        {
                            IsAuthSuccessful = false,
                            User = { },
                            ErrorMessage = userResult.ValidateResponse
                        };

                    }

                }
                else
                if (!checkUserResult.IsValidUser || !checkUserResult.IsActive || checkUserResult.IsUserLocked)
                {
                    return new AuthResponseModel { IsAuthSuccessful = false, User = { }, ErrorMessage = checkUserResult.ErrorMessage };
                }
                else
                {
                    return new AuthResponseModel { IsAuthSuccessful = false, User = { }, ErrorMessage = "No Error" };
                }



            }
            catch (Exception ex)
            {
                return new AuthResponseModel { IsAuthSuccessful = false, User = { }, ErrorMessage = ex.Message };
            }

            TokenModel GetToken(UserDetailsModel user)
            {

                TokenModel Token = _jwtHandler.GetTokenObject(HttpContext, _context, user);
                return Token;
            }


        }

        [HttpPost]
        [Route("log-off")]
        public ResponseModel LogOff([FromBody] LogOffRequestModel userReqModel)
        {

            try
            {
                var userName = Helper.DecryptValue(userReqModel.UserName);

                var result = _context.GetResponseWithNoDataReturn.FromSqlRaw(Constants.app_SP_LogOff, userReqModel.UserGUID, userName, Helper.GetClientIP).ToList()[0];

                return new ResponseModel { IsError = false, ErrorMessage = result.ErrorMessage, ValidateResponse = result.ValidateResponse };

            }
            catch (Exception ex)
            {
                return new ResponseModel { IsError = true, ErrorId = 1, ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message) };
            }

        }
    }
}
