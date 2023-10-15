using Microsoft.EntityFrameworkCore;
using co.app.common;
using co.app.common.WebApi;
using co.app.common.WebApi.AccessMatrix.Get;
using co.app.common.WebApi.Attribute.Get;
using co.app.common.WebApi.Role;
using co.app.common.WebApi.UserAccess;
using co.app.common.WebApi.UserAttribute.Get;

namespace co.app.api.Models
{
    public class MainContext : DbContext
    {
        public MainContext()
        {
        }

        public MainContext(DbContextOptions<MainContext> options) : base(options)
        {
            Database.SetCommandTimeout(120000);
            this.ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionBuilder)
        {
            optionBuilder.UseSqlServer(Helper.GetConnectionString);
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<UserModel>().Ignore(c => c.MugShot);
        }

        public virtual DbSet<ResponseModel> GetResponseWithNoDataReturn { get; set; }
        public virtual DbSet<ResponseModelWithGuid> GetResponseWithGuid { get; set; }
        public virtual DbSet<UserCheckModel> UserCheckResponseModel { get; set; }
        public virtual DbSet<UserDetailsModel> UserDetailsModel { get; set; }
        public virtual DbSet<TokenModel> MssTokenModel { get; set; }
        public virtual DbSet<UserModel> Users { get; set; }
        public virtual DbSet<Role> UpsertRole { get; set; }
        public virtual DbSet<AccessMatrixListModel> AccessMatrixListModels { get; set; }
        public virtual DbSet<AttributeListModel> AttributeListModels { get; set; } 
        public virtual DbSet<Role> RoleModels { get; set; }
        public virtual DbSet<UserAttribute> UserAttributes { get; set; }
        public virtual DbSet<UserAccountNameModel> UserAccountNameModel { get; set; }
        public virtual DbSet<UserAccessCheckResponseModel> UserAccessCheckResponseModel { get; set; }


    }
}
