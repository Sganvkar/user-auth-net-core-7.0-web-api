using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace co.app.common.WebApi.UserAttribute.Get
{
    public class UserAttribute
    {
        [Key]
        public Guid? UserAttributeId { get; set; }
        public string? UserAttributeName { get; set; }
        public string? UserAttributeDescription { get; set; }
        public Guid? AttributeId { get; set; }
        public string? AttributeName { get; set; }
        public string? AttributePath { get; set; }
        public string? CrudIds { get; set; }
        public string? AttributeAccessList { get; set; }
        public Guid? CreatedById { set; get; }
        public DateTime? CreatedDate { get; set; }
        public Guid? ModifiedById { set; get; }
        public DateTime? ModifiedDate { get; set; }
    }
}
