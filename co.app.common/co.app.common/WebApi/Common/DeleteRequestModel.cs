using System;
using System.Collections.Generic;
using System.Text;

namespace co.app.common.WebApi.Common
{
    public class DeleteRequestModel
    {
        public Guid Id { get; set; }
        public Guid DeletedById { get; set; }
    }
}
