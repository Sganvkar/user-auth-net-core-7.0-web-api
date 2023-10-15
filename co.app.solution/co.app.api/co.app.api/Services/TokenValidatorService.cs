using Microsoft.AspNetCore.Mvc.Filters;
using System.Security.Claims;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using co.app.api.Models;
using co.app.api.JWTFeatures;
using co.app.common.WebApi;
using co.app.common.Definitions;
using co.app.common;
using mss.common.Definitions;

namespace mss.api.Services
{
    public class TokenValidatorService
    {
        private readonly co.app.api.Models.MainContext _context;
        private IConfigurationSection _validatorConfig;
        private readonly TokenService _tokenService;
        private readonly JWTHandler _jwtHandler;

        private string? IncomingTokenValue { get; set; }
        private string? IncomingAccountName { get; set; }
        private string? IncomingIpAddress { get; set; }

        private string? TargetTokenValue { get; set; }

        public TokenValidatorService(IConfiguration configuration, co.app.api.Models.MainContext context, TokenService tokenService, JWTHandler JWTHandler)
        {
            _validatorConfig = configuration.GetSection("AccessTokenValidator");
            _context = context;
            _tokenService = tokenService;
            _jwtHandler = JWTHandler;
        }




        public bool DoValidation(TokenModel targetToken, ActionExecutingContext actionExecutingContext)
        {
            if (!bool.Parse(_validatorConfig.GetSection("isTurnOn").Value)) return true;

            var TargetTokenValue = targetToken.CurrentToken;
            IncomingTokenValue = actionExecutingContext.HttpContext.Request.Headers[CustomHttpHeaders.Authorization];
            if (!TargetTokenValue.Equals(IncomingTokenValue, StringComparison.CurrentCultureIgnoreCase)) return false;


            var tokenValidationParameters = _jwtHandler.GetTokenValidationParametersForExpired();

            var tokenHandler = new JwtSecurityTokenHandler();

            _ = tokenHandler.ValidateToken(TargetTokenValue, tokenValidationParameters, out SecurityToken validatedToken);

            var jwtSecurityToken = (JwtSecurityToken)validatedToken;

            if (jwtSecurityToken == null || !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase))
            {
                return false;
            }


            var userGuid = actionExecutingContext.HttpContext.Request.Headers[CustomHttpHeaders.UserGUID];
            var arrayOfUsers = _context.UserAccountNameModel.FromSqlRaw(
                Constants.app_SP_GetUserNameByUserGuid, userGuid).ToList();

            if (arrayOfUsers.Count == 0 || arrayOfUsers.Count > 1)
            {
                return false;
            }

            IncomingAccountName = arrayOfUsers[0].UserName;
            string accountName = _jwtHandler.ExtractClaimValueFromToken(jwtSecurityToken, ClaimTypes.Name);
            if (!accountName.Equals(IncomingAccountName, StringComparison.CurrentCultureIgnoreCase)) return false;

            IncomingIpAddress = actionExecutingContext.HttpContext.Connection.RemoteIpAddress.ToString();
            string ipAddress = _jwtHandler.ExtractClaimValueFromToken(jwtSecurityToken, CustomClaim.IpAddress);
            if (!ipAddress.Equals(IncomingIpAddress, StringComparison.CurrentCultureIgnoreCase)) return false;

            return true;
        }

    }
}
