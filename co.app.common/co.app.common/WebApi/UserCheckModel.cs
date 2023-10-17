using System.ComponentModel.DataAnnotations;

namespace co.app.common.WebApi
{
    public class UserCheckModel
    {   [Key]
        public Guid UserId { get; set; }
        public required string Username { get; set; }
        public string? Password { get; set; }
        public bool IsActive { get; set; }
        public bool IsValidUser { get; set; }
        public int ErrorId { get; set; }
        public bool? IsError { get; set; }
        public string? ErrorMessage { get; set; }
        public string? ValidateResponse { get; set; }
        public bool IsUserLocked { get; set; }
    }
}
