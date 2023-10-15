
namespace co.app.common.WebApi
{
    public class UserAuthReponseModel: UserDetailsModel
    {
        public int? TokenID { get; set; }
        public string Token { get; set; }
        public bool? IsLoginFailed { get; set; }
        public bool? IsValidUser { get; set; }

    }
}
