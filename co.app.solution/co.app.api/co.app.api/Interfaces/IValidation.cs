using co.app.common.WebApi;
using Microsoft.AspNetCore.Mvc.Filters;

namespace mss.api.Interfaces
{
    public interface IValidation
    {
        bool DoValidation(TokenModel targetTokenModel, ActionExecutingContext actionExecutingContext);
    }
}
