using co.app.api.Models;
using co.app.common.WebApi;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Controllers;
using Microsoft.AspNetCore.Mvc.Filters;
using mss.api.Services;

namespace co.app.api.Filters
{
    public class ApiAuthorizationFilter : ActionFilterAttribute
    {
        private Models.MainContext Context;
        public string AttributeName;
        public string AccessName;

     
        public ApiAuthorizationFilter(string AttributeName, string AccessName)
        {
            this.AttributeName = AttributeName;
            this.AccessName = AccessName;
        }
        public override void OnActionExecuting(ActionExecutingContext context)
        {
            this.Context = context.HttpContext.RequestServices.GetRequiredService<Models.MainContext>();
            RequestModel requestModel = null;
            try
            {
                foreach (ControllerParameterDescriptor param in context.ActionDescriptor.Parameters)
                {
                    if (param.ParameterInfo.CustomAttributes.Any(
                        attr => (attr.AttributeType == typeof(Microsoft.AspNetCore.Mvc.FromBodyAttribute)
                                    || attr.AttributeType == typeof(Microsoft.AspNetCore.Mvc.FromFormAttribute))
                        )
                    )
                    {
                        requestModel = (RequestModel)context.ActionArguments[param.Name];
                    }
                }

                if (requestModel != null)
                {
                    var isPermitted = RoleGuardService.IsPermitted(Context, requestModel.UserGUID,
                                    this.AttributeName, this.AccessName);

                    if (isPermitted)
                    {
                        base.OnActionExecuting(context);
                    }
                    else
                    {
                        var errResult = new ResponseModel { IsError = true, ErrorMessage = "You are not Authorized!!!" };
                        context.Result = new UnauthorizedObjectResult(errResult); //new ForbidResult();
                    }
                }
                else
                {
                    var errResult = new ResponseModel { IsError = true, ErrorMessage = "You are not Authorized!!!" };
                    context.Result = new UnauthorizedObjectResult(errResult); //new ForbidResult();
                }
            }
            catch (Exception ex)
            {
                var errResult = new ResponseModel { IsError = true, ErrorMessage = "Invalid arguments of Action : " + ex.Message };
                context.Result = new BadRequestObjectResult(errResult);
            }
        }
    }
}
