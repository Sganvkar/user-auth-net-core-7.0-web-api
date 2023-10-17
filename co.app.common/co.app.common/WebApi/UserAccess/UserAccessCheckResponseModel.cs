using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace co.app.common.WebApi.UserAccess
{
    public class UserAccessCheckResponseModel: ResponseInheritanceModel
    {
        public int? AccessCount { get; set; }
        public int? TotalAccessCount { get; set; }
        public string AccessLevels { get; set; }
    }
}
