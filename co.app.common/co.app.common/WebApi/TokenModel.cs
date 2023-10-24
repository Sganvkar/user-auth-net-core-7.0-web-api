﻿using System.ComponentModel.DataAnnotations;

namespace co.app.common.WebApi
{
    public class TokenModel
    {
        [Key]
        public Guid? ID { get; set; }
        public string? GrantedTo { get; set; }
        public string? CurrentToken { get; set; }
        public string? RotativeToken { get; set; }
        public DateTime? TokenValidFrom { get; set; }
        public DateTime? TokenValidTo { get; set; }
        public string? ClientID { get; set; }
        public DateTime? CreatedDate { get; set; }
    }

    public class RefreshTokenRequestModel : RequestModel
    {
        public string Token { get; set; }
        public string RefreshToken { get; set; }
    }
}
