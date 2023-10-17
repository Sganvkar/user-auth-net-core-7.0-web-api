using System.ComponentModel.DataAnnotations;

namespace co.app.common.WebApi
{
    public class ResponseModel
    {  
        [Key]
        public int ErrorId { get; set; }
        public bool? IsError { get; set; }
        public string? ErrorMessage { get; set; }
        public string? ValidateResponse { get; set; }
    }

    public class ResponseModelWith<T>
    {
        public int ErrorId { get; set; }
        public bool? IsError { get; set; }
        public string? ErrorMessage { get; set; }
        public string ValidateResponse { get; set; }
        public List<T>? arrayOfItems { get; set; }
    }

    public class ResponseModelWithGuid
    {
        [Key]
        public int ErrorId { get; set; }
        public bool? IsError { get; set; }
        public string? ErrorMessage { get; set; }
        public string? ValidateResponse { get; set; }
        public Guid ObjectGuid { get; set; }
    }

    public class ResponseInheritanceModel
    {
        [Key]
        public int ErrorId { get; set; }
        public bool? IsError { get; set; }
        public string? ErrorMessage { get; set; }
        public string? ValidateResponse { get; set; }
    }
}
