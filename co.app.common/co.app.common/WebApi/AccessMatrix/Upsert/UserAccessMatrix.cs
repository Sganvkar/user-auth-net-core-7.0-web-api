using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace co.app.common.WebApi.AccessMatrix.Upsert
{
    public class UserAccessMatrix
    {
        public Guid? UserAccessMatrixId { get; set; }
        public bool IsActive { get; set; }
        public string? UserAccessDescription { get; set; }
        public Guid RoleId { get; set; }
        public Guid CreatedById { get; set; }
        public required List<Guid> UserAttributeIds { get; set; }
    }

    public class UserAccessMatrixFieldvalues
    {
        public Guid RoleId { get; set; }
        public Guid UserAttributeId { get; set; }
    }
}
