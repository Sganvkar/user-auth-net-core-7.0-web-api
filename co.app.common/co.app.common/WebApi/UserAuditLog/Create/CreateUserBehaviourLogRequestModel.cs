
namespace co.app.common.WebApi.UserAuditLog.Create
{
    public class CreateUserBehaviourLogRequestModel : RequestModel
    {
        public string AuditLogObjectName { get; set; }
        public string ClientComputerName { get; set; }
        public Guid? ObjectGUID { get; set; }
        public string ShortDescription { get; set; }
        public string Details { get; set; }
        public long? ObjectID { get; set; }
        public string UserName { get; set; }
    }
}
