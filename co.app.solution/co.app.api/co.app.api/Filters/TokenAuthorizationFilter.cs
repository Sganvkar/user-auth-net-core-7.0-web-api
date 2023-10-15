using co.app.api.Models;
using co.app.common;
using co.app.common.Definitions;
using co.app.common.WebApi;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.EntityFrameworkCore;
using mss.api.Services;

namespace co.app.api.Filters
{
    public class TokenAuthorizationFilter: ActionFilterAttribute
    {

        private readonly Models.MainContext _context;
        private readonly TokenValidatorService TokenValidator;

        public TokenAuthorizationFilter(
            Models.MainContext context
            )
        {
            _context = context;
        }

        public override void OnActionExecuting(ActionExecutingContext actionExecutingContext)
        {

            int TokenID = int.Parse(actionExecutingContext.HttpContext.Request.Headers[CustomHttpHeaders.TokenID]);

            var arrayOfTokens = _context.MssTokenModel.FromSqlRaw(
                Constants.app_SP_GetTokenByTokenID, TokenID).ToList();

            if (arrayOfTokens.Count == 0 || arrayOfTokens.Count > 1)
            {
                actionExecutingContext.Result = new ObjectResult(actionExecutingContext.ModelState)
                {
                    Value = null,
                    StatusCode = StatusCodes.Status403Forbidden
                };
            }

            TokenModel targetToken = arrayOfTokens[0];

            if (targetToken.TokenValidTo < DateTime.Now ||
                !TokenValidator.DoValidation(arrayOfTokens[0], actionExecutingContext)
                )
            {
                actionExecutingContext.Result = new ObjectResult(actionExecutingContext.ModelState)
                {
                    Value = null,
                    StatusCode = StatusCodes.Status403Forbidden
                };
            }
        }
    }
}
