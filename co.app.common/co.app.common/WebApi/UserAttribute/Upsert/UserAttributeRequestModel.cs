using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace co.app.common.WebApi.UserAttribute.Upsert
{
    public class UserAttributeRequestModel : RequestModel
    {
        [Key]
        public Guid? UserAttributeId { get; set; }
        public string? UserAttributeName { get; set; }
        public string? UserAttributeDescription { get; set; }
        public Guid? AttributeId { set; get; }
        public string? CrudIds { get; set; }
        public Guid? CreatedById { set; get; }
    }
}
