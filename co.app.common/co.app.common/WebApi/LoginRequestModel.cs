
namespace co.app.common.WebApi
{
    public class LoginRequestModel
    {
        public required string Username { get; set; }
        public required string ClientIP { get; set; }
        public required string Password { get; set; } 
    }
}
