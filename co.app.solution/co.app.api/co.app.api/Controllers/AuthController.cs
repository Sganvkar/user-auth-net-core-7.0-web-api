using co.app.api.Models;
using co.app.common;
using co.app.common.WebApi;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using mss.api.Services;

namespace mss.api.Controllers
{
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        private readonly co.app.api.Models.MainContext _context;
        private readonly TokenService tokenService;
        public AuthController(co.app.api.Models.MainContext context, TokenService tokenService)
        {
            _context = context;
            this.tokenService = tokenService;
        }

        [HttpPost]
        [Route("validateUser")]
        public AuthResponseModel ValidateUser([FromBody] LoginRequestModel requestBody)
        {
            try
            {
                var username = Helper.DecryptValue(requestBody.Username);
                var password = Helper.DecryptValue(requestBody.Password);

                var checkUserResult = _context.UserCheckResponseModel.FromSqlRaw(Constants.app_SP_CheckUser, username, requestBody.ClientIP).ToList()[0];

                if (checkUserResult.IsValidUser)
                {

                    var passwordFromDb = Helper.DecryptValue(checkUserResult.Password);
                    if (passwordFromDb == password)
                    {
                        var userDetails = _context.UserDetailsModel.FromSqlRaw(Constants.app_SP_GetUserDetails, username, requestBody.ClientIP).ToList()[0];
                        if (userDetails.MugShot != null)
                        {
                            //userDetails.MugShot = Convert.ToBase64String(userDetails.MugShot);
                        }

                        TokenModel mssToken = GetMssToken(userDetails);

                        TokenModel token = _context.MssTokenModel.FromSqlRaw(
                           Constants.app_SP_CreateTokenInDB, userDetails.UserName, mssToken.CurrentToken, mssToken.CurrentToken,
                           mssToken.TokenValidFrom.Value, mssToken.TokenValidTo.Value, mssToken.ClientID).ToList()[0];

                        userDetails.TokenID = token.ID;
                        userDetails.Token = token.CurrentToken;
                        userDetails.RefreshToken = token.RotativeToken;
                        userDetails.IsError = false;
                        userDetails.ErrorMessage = "";
                        userDetails.ValidateResponse = "";

                        return new AuthResponseModel { IsAuthSuccessful = true, User = userDetails, ErrorMessage = "" };
                    }
                    else
                    {

                        var user = _context.Users.FirstOrDefault(u => u.UserId == checkUserResult.UserId);

                        if (user != null)
                        {
                            if (user.UnsuccessfulCount >= Constants.maxUnsuccessfullLoginAttempts)
                            {
                                user.IsUserLocked = true;
                            }
                            else
                            {
                                user.UnsuccessfulCount++;
                            }

                            _context.SaveChanges();
                        }

                        return new AuthResponseModel
                        {
                            IsAuthSuccessful = false,
                            User = { },
                            ErrorMessage = "Login Failed, " + (Constants.maxUnsuccessfullLoginAttempts - user.UnsuccessfulCount) + " Attempts remaining"
                        };

                    }

                }
                else if (!checkUserResult.IsValidUser || !checkUserResult.IsActive || checkUserResult.IsUserLocked)
                {
                    return new AuthResponseModel { IsAuthSuccessful = false, User = { }, ErrorMessage = checkUserResult.ErrorMessage };
                }

                return new AuthResponseModel { IsAuthSuccessful = false, User = { }, ErrorMessage = "" };


            }
            catch (Exception ex)
            {
                return new AuthResponseModel { IsAuthSuccessful = false, User = { }, ErrorMessage = ex.Message };
            }

            TokenModel GetMssToken(UserDetailsModel user)
            {

                TokenModel mssToken = tokenService.GenerateToken(user, _context, HttpContext);
                return mssToken;
            }


        }

        [HttpPost]
        [Route("LogOff")]
        public ResponseModel LogOff([FromBody] LogOffRequestModel userReqModel)
        {

            try
            {
                var userName = Helper.DecryptValue(userReqModel.UserName);

                var result = _context.GetResponseWithNoDataReturn.FromSqlRaw(Constants.app_SP_LogOff, userReqModel.UserGUID, userName, userReqModel.ClientIP).ToList()[0];

                return new ResponseModel { IsError = false, ErrorMessage = result.ErrorMessage, ValidateResponse = result.ValidateResponse };

            }
            catch (Exception ex)
            {
                return new ResponseModel { IsError = true, ErrorId = 1, ErrorMessage = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message), ValidateResponse = (ex.InnerException != null ? ex.InnerException.ToString() : ex.Message) };
            }

        }
    }
}
