using co.app.common.WebApi;

namespace co.app.common.WebApi.Attribute.Upsert
{
    public class AttributeRequestModel : RequestModel
    {
        public Guid? AttributeId { set; get; }
        public required string AttributeName { set; get; }
        public required string AttributePath { set; get; }
        public bool? IsComponent { get; set; }
    }
}
