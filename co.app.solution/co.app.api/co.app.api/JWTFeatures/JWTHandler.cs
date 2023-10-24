using Microsoft.IdentityModel.Tokens;
using co.app.common.WebApi;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using mss.common.Definitions;
using co.app.api.Models;

namespace co.app.api.JWTFeatures
{
    public class JWTHandler
    {
        private readonly IConfiguration _configuration;

        private IConfigurationSection _jwtSettings;
        public double TokenExpiryMinutes { get; private set; }
        public double RefreshTokenExpiryDays { get; private set; }
        public SymmetricSecurityKey SecurityKey { get; private set; }
        public string ValidIssuer { get; private set; }
        public string ValidAudience { get; private set; }
        public TokenValidationParameters TokenValidationParameters { get; private set; }
        public string ClientID { get; private set; }
        public JWTHandler(IConfiguration configuration)
        {
            _configuration = configuration;
            SetupJwtSettings();
        }
        private void SetupJwtSettings()
        {
            _jwtSettings = _configuration.GetSection("JwtSettings");
            var key = Encoding.UTF8.GetBytes(_jwtSettings.GetSection("securityKey").Value);//this encoding should match with startup.cs file AddJwtBearer method.
            SecurityKey = new SymmetricSecurityKey(key);
            TokenExpiryMinutes = Convert.ToDouble(_jwtSettings.GetSection("expiryInMinutes").Value);
            RefreshTokenExpiryDays = Convert.ToDouble(_jwtSettings.GetSection("refreshExpiryInDays").Value);
            ValidIssuer = _jwtSettings.GetSection("validIssuer").Value;
            ValidAudience = _jwtSettings.GetSection("validAudience").Value;
            SetTokenValidationParameters();
        }
        private void SetTokenValidationParameters()
        {
            TokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuer = false,
                ValidateAudience = false,
                ValidateLifetime = true, //here we are saying that we don't care about the token's expiration date
                ValidateIssuerSigningKey = true,
                ValidIssuer = ValidIssuer,
                ValidAudience = ValidAudience,
                IssuerSigningKey = SecurityKey,
                // set clockskew to zero so tokens expire exactly at token expiration time (instead of 5 minutes later)
                ClockSkew = TimeSpan.Zero

                ////options used startup.cs file AddJwtBearer method
                //ValidateIssuer = false,
                //ValidateAudience = false,
                //ValidateLifetime = true,
                //ValidateIssuerSigningKey = true,
                ////ValidIssuer = ValidIssuer,
                ////ValidAudience = ValidAudience,
                //IssuerSigningKey = SecurityKey,
                // set clockskew to zero so tokens expire exactly at token expiration time (instead of 5 minutes later)
                //ClockSkew = TimeSpan.Zero
            };
        }

        public JwtSecurityToken GetJwtSecurityToken(HttpContext httpContext, UserDetailsModel user, bool isRefresh = false)
        {
            var claims = this.GetClaims(user, httpContext);
            var jwtSecurityToken = this.GenerateJwtSecurityToken(claims, isRefresh);
            return jwtSecurityToken;
        }
        public TokenModel GetTokenObject(HttpContext httpContext, MainContext _context, UserDetailsModel user)
        {
            var jwtSecurityToken = GetJwtSecurityToken(httpContext, user);
            var jwtSecurityTokenRefresh = GetJwtSecurityToken(httpContext, user, true);
            TokenModel token = new TokenModel
            {
                GrantedTo = user.UserName,
                CurrentToken = new JwtSecurityTokenHandler().WriteToken(jwtSecurityToken),
                RotativeToken = new JwtSecurityTokenHandler().WriteToken(jwtSecurityTokenRefresh),
                CreatedDate = DateTime.Now,
                TokenValidFrom = DateTime.Now,
                TokenValidTo = DateTime.Now.AddMinutes(1 * 60),
                ClientID = ClientID
            };
            return token;
        }

        private JwtSecurityToken GenerateJwtSecurityToken(List<Claim> claims, bool isRefresh = false)
        {
            var mins = TokenExpiryMinutes;
            if (isRefresh)
            {
                mins = RefreshTokenExpiryDays * 24 * 30;//to minutes. TODO should it be (2 months: 60)?
            }
            var jwtSecuritytoken = new JwtSecurityToken(
                issuer: ValidIssuer,
                audience: ValidAudience,
                claims: claims,
                expires: DateTime.Now.AddMinutes(mins),
                signingCredentials: this.GetSigningCredentials());
            return jwtSecuritytoken;
        }
        private SigningCredentials GetSigningCredentials()
        {
            SigningCredentials signingCredentials = new SigningCredentials(SecurityKey, SecurityAlgorithms.HmacSha256);
            return signingCredentials;
        }

        public List<Claim> GetClaims(UserDetailsModel user, HttpContext httpContext)
        {
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.Name, user.UserName)
            };
            if (user.RoleNames == null)
            {
                user.RoleNames= "";
            }
            var roleArray = user.RoleNames.Split(',').Distinct().ToList();
            for (int i = 0; i < roleArray.Count; i++)
            {
                var claim = new Claim(ClaimTypes.Role, roleArray[i]);
                claims.Add(claim);
            }

            AddClaimsFromHttpContext(user, claims, httpContext);

            return claims;
        }

        private static string GenerateClientID(string accountName, HttpContext httpContext)
        {
            Random random = new Random();
            byte[] bytes = new byte[16];
            for (int i = 0; i < bytes.Length; i++)
                bytes[i] = (byte)random.Next(256);
            return new Guid(bytes).ToString();
        }
        private void AddClaimsFromHttpContext(UserDetailsModel user, List<Claim> claims, HttpContext httpContext)
        {
            if (httpContext == null) return;
            Claim claim = new Claim(CustomClaim.IpAddress, httpContext.Connection.RemoteIpAddress.ToString());
            ClientID = GenerateClientID(user.UserName, httpContext);
           
            claims.Add(claim);
        }

        public TokenValidationParameters GetTokenValidationParametersForExpired()
        {
            var parameters = TokenValidationParameters.Clone();
            parameters.ValidateLifetime = false;
            return parameters;
        }

        public string ExtractClaimValueFromToken(JwtSecurityToken securityToken, string claimType)
        {
            string claimValue = null;
           
            foreach (Claim claim in securityToken.Claims.ToList())
            {
                if (claim.Type.Equals(claimType))
                {
                    claimValue = claim.Value;
                    break;
                }
            }
            return claimValue;
        }

        public ClaimsPrincipal GetPrincipalFromExpiredToken(string token)
        {
            var tokenValidationParameters = GetTokenValidationParametersForExpired();
            var tokenHandler = new JwtSecurityTokenHandler();
            var principal = tokenHandler.ValidateToken(token, tokenValidationParameters, out SecurityToken securityToken);
            if (securityToken == null)
            {
                throw new SecurityTokenException("Invalid token");
            }
            var jwtSecurityToken = securityToken as JwtSecurityToken;
            if (jwtSecurityToken == null || !jwtSecurityToken.Header.Alg.Equals(SecurityAlgorithms.HmacSha256, StringComparison.InvariantCultureIgnoreCase))
            {
                throw new SecurityTokenException("Invalid token");
            }
            return principal;
        }
    }
}
