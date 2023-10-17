using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace co.app.common.WebApi
{
    public class UserDetailsModel
    {
        [Key]
        public Guid? UserId { get; set; }
        public string? UserName { get; set; }
        public string? FirstName { get; set; }
        public string? Initials { get; set; }
        public string? LastName { get; set; }
        public string? JobTitle { get; set; }
        public string? UserEmail { get; set; }
        public bool? IsUserLocked { get; set; }
        public bool? IsActive { get; set; }
        public DateTime? InactiveDate { get; set; }
        public string? InactiveReason { get; set; }
        public string? ValidateResponse { get; set; }
        public bool IsError { get; set; }
        public int ErrorId { get; set; }
        public string? ErrorMessage { get; set; }
        public string? RoleIds { get; set; }
        public string? RoleNames { get; set; }
        public string? GroupIds { get; set; }
        public string? GroupNames { get; set; }
        public string? RefreshToken { get; set; }
        public Guid? CreatedBy { get; set; }
        public string? Location { get; set; }
        public Byte[]? MugShot { get; set; }
        public bool? ISSA { get; set; }
        public Guid? TokenID { get; set; }
        public string? Token { get; set; }

    }
}
