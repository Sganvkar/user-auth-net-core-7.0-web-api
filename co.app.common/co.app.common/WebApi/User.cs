using System.ComponentModel.DataAnnotations;

namespace co.app.common.WebApi
{
    public class UserModel
    {
        [Key]
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public string FirstName { get; set; }
        public string? Initials { get; set; }
        public string LastName { get; set; }
        public string? Location { get; set; }
        public string UserEmail { get; set; }
        public string PhoneNumber { get; set; }
        public bool IsActive { get; set; }
        public DateTime? InactiveDate { get; set; }
        public string InactiveReason { get; set; }
        public bool IsUserLocked { get; set; }
        public int UnsuccessfulCount { get; set; }
        public string? WorkForIds { get; set; }
        public string? DefaultAttributeIds { get; set; }
        public Byte[] MugShot { get; set; }
        public string? MugShotImage { get; set; }
        public string Gender { get; set; }
        public Guid CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public Guid? ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public bool IsDeleted { get; set; }
        public Guid? DeletedBy { get; set; }
        public DateTime? DeletedDate { get; set; }
        public string? JobTitle { get; set; }
    }

    public class UserAccountNameModel
    {
        [Key]
        public Guid UserID { get; set; }
        public string UserName { get; set; }
        public string FirstName { get; set; }
        public string LastName { set; get; }
    }

}
