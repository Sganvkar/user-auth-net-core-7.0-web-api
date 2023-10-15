using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace co.app.common.WebApi.AccessMatrix.Get
{
    public class AccessMatrixListModel
    {
        [Key]
        public Guid UserAccessMatrixId { get; set; }
        public Guid RoleId { get; set; }
        public string? RoleName { get; set; }
        public bool? IsActive { get; set; }
        public Guid? CreatedById { get; set; }
        public Guid? ModifiedById { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public string? CreatedBy { get; set; }
        public string? ModifiedBy { get; set; }
        public string? UserAttributeDetails { get; set; }

    }
}
