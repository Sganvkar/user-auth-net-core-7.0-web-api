
namespace co.app.common.WebApi
{
    public class AuthResponseModel
    {
        public bool IsAuthSuccessful { get; set; }
        public string ErrorMessage { get; set; }
        public UserDetailsModel User { get; set; }
    }
}
