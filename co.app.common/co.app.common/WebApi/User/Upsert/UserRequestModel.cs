using Microsoft.AspNetCore.Http;
using System;

namespace co.app.common.WebApi.User.Upsert
{
    public class UserRequestModel: RequestModel
    {
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string JobTitle { get; set; }
        public string Location { get; set; }
        public byte[] MugShot { get; set; }
        public string RoleIds { get; set; }
        public string DefaultAttributeIds { get; set; }
        public IFormFile? UserPhoto { get; set; }
        public bool IsUserLocked { get; set; }
        public bool IsActive { get; set; }

    }
}
