namespace co.app.api.Models
{
    public class ExceptionModel
    {
        public string ClassName { get; set; }
        public string MethodName { get; set; }
        public string Message { get; set; }
        public string Code { get; set; }
        public string UserGUID { get; set; }
        public string UserName { get; set; }
        public string ClientIP { get; set; }
        public string ClientComputerName { get; set; }
    }
}
