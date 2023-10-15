using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace co.app.common.WebApi.Attribute.Get
{
    public class AttributeListModel
    {
        [Key]
        public Guid AttributeId { set; get; }
        public string? AttributeName { set; get; }
        public required string AttributePath { set; get; }
        public Guid? CreatedById { set; get; }
        public DateTime? CreatedDate { set; get; }
        public Guid? ModifiedById { set; get; }
        public DateTime? ModifiedDate { set; get; }
        public string? CreatedBy { get; set; }
        public string? ModifiedBy { get; set; }
        public bool? IsComponent { get; set; }
    }
    
}
