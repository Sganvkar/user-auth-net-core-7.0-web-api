using co.app.api.Models;
using co.app.common;
using Microsoft.EntityFrameworkCore;

namespace mss.api.Services
{
    public class RoleGuardService
    {
        public static bool IsPermitted(co.app.api.Models.MainContext _context, Guid? UserGUID, string PathURL, string AccessLevel = null)
        {
            bool permitted = false;
            try
            {

                if (PathURL != null && PathURL.Substring(0, 1) == "/")
                {
                    PathURL = PathURL.Substring(1);
                }
                if (AccessLevel != null && AccessLevel.Trim().Length == 0)
                {
                    AccessLevel = null;
                }
                var checkAccessResult = _context.UserAccessCheckResponseModel.FromSqlRaw(Constants.app_SP_CheckUserAccess,
                    UserGUID, PathURL, AccessLevel).ToList()[0];

                var tmp = (checkAccessResult.AccessLevels != null) ? checkAccessResult.AccessLevels.Split(',') : new string[0];
                var ual = tmp.ToList<string>();
                var found = ual.Find((ua) => { return ua.ToLower() == AccessLevel.ToLower(); });
                permitted = found != null && (found.ToLower() == AccessLevel.ToLower());

            }
            catch (Exception ex)
            {
                permitted = false;
            }

            return permitted;
        }
    }
}
