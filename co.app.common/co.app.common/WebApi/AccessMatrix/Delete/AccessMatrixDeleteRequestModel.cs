using System;
using System.Collections.Generic;
using System.Text;

namespace co.app.common.WebApi.AccessMatrix.Delete
{
    public class AccessMatrixDeleteRequestModel
    {
        public Guid UserAccessMatrixId { get; set; }
        public Guid DeletedById { get; set; }
    }
}
