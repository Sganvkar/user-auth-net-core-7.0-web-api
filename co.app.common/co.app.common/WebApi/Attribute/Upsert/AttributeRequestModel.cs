using co.app.common.WebApi;

namespace co.app.common.WebApi.Attribute.Upsert
{
    public class AttributeRequestModel : RequestModel
    {
        public Guid? AttributeId { set; get; }
        public string AttributeName { set; get; }
        public string AttributePath { set; get; }
        public Guid CreatedById { set; get; }
        public bool? IsComponent { get; set; }
    }
}
