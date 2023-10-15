using Microsoft.EntityFrameworkCore;
using co.app.common.WebApi;

namespace co.app.api.Models
{
    public class LoggingContext: DbContext
    {
        public LoggingContext()
        {

        }

        public LoggingContext(DbContextOptions options)
           : base(options)
        {
            Database.SetCommandTimeout(120000);
            this.ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
        }
        public virtual DbSet<ResponseModel> StandardResponseModel { get; set; }

    }
}
