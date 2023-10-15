using co.app.api.JWTFeatures;
using co.app.api.Models;
using co.app.common.WebApi;

namespace mss.api.Services
{
    public class TokenService
    {
        private readonly JWTHandler _jwtHandler;

        public TokenService(JWTHandler jwtHandler)
        {
            _jwtHandler = jwtHandler;
        }

        public TokenModel GenerateToken(UserDetailsModel user, co.app.api.Models.MainContext _context, HttpContext httpContext)
        {
            TokenModel token = _jwtHandler.GetMssTokenObject(httpContext, _context, user);
            return token;
        }

    }
}
