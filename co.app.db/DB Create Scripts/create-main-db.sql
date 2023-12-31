USE [master]
GO
/****** Object:  Database [BaseCrocs]    Script Date: 17-10-2023 21:25:33 ******/
CREATE DATABASE [BaseCrocs]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BaseCrocs', FILENAME = N'E:\MSSQL16.MSSQLSERVER\MSSQL\DATA\BaseCrocs.mdf' , SIZE = 73728KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BaseCrocs_log', FILENAME = N'E:\MSSQL16.MSSQLSERVER\MSSQL\DATA\BaseCrocs_log.ldf' , SIZE = 73728KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BaseCrocs] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BaseCrocs].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BaseCrocs] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BaseCrocs] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BaseCrocs] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BaseCrocs] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BaseCrocs] SET ARITHABORT OFF 
GO
ALTER DATABASE [BaseCrocs] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BaseCrocs] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BaseCrocs] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BaseCrocs] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BaseCrocs] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BaseCrocs] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BaseCrocs] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BaseCrocs] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BaseCrocs] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BaseCrocs] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BaseCrocs] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BaseCrocs] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BaseCrocs] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BaseCrocs] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BaseCrocs] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BaseCrocs] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BaseCrocs] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BaseCrocs] SET RECOVERY FULL 
GO
ALTER DATABASE [BaseCrocs] SET  MULTI_USER 
GO
ALTER DATABASE [BaseCrocs] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BaseCrocs] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BaseCrocs] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BaseCrocs] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BaseCrocs] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BaseCrocs] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BaseCrocs', N'ON'
GO
ALTER DATABASE [BaseCrocs] SET QUERY_STORE = ON
GO
ALTER DATABASE [BaseCrocs] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BaseCrocs]
GO
/****** Object:  UserDefinedTableType [dbo].[udtUserAccessMatrixFieldvalues]    Script Date: 17-10-2023 21:25:33 ******/
CREATE TYPE [dbo].[udtUserAccessMatrixFieldvalues] AS TABLE(
	[RoleId] [uniqueidentifier] NOT NULL,
	[UserAttributeId] [uniqueidentifier] NOT NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[CheckUserSAdmin]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[CheckUserSAdmin](@UserId NVARCHAR(255))
RETURNS INT
AS
BEGIN
	DECLARE @SARoleName VARCHAR(50) = 'SAdmin';
    DECLARE @Result INT = 0;
    
	IF EXISTS( SELECT 1
        FROM Users U
        INNER JOIN UserInRole UIR ON UIR.USERID = U.UserId
        INNER JOIN Role R ON R.RoleId = UIR.ROLEID
        WHERE U.UserId = @UserId AND R.RoleName = @SARoleName)
		
		BEGIN
			RETURN 1;
		END
	
		RETURN 0;
    
END;
GO
/****** Object:  UserDefinedFunction [dbo].[GetSAdminName]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[GetSAdminName]()
RETURNS INT
AS
BEGIN
	DECLARE @SARoleName VARCHAR(50) = 'SAdmin';
    
    RETURN @SARoleName;
END;
GO
/****** Object:  Table [dbo].[AttributeCategories]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AttributeCategories](
	[AttributeCategoryId] [uniqueidentifier] NOT NULL,
	[AttributeCategoryName] [uniqueidentifier] NOT NULL,
	[Description] [varchar](500) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedById] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedById] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedById] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
 CONSTRAINT [PK_AttributeCategories] PRIMARY KEY CLUSTERED 
(
	[AttributeCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Attributes]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Attributes](
	[AttributeId] [uniqueidentifier] NOT NULL,
	[AttributeName] [varchar](100) NULL,
	[AttributePath] [varchar](100) NOT NULL,
	[IsComponent] [bit] NOT NULL,
	[CreatedById] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedById] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedById] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Attributes] PRIMARY KEY CLUSTERED 
(
	[AttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_Attributes_1] UNIQUE NONCLUSTERED 
(
	[AttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Crud]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Crud](
	[CrudId] [varchar](200) NOT NULL,
	[CrudName] [varchar](6) NOT NULL,
 CONSTRAINT [PK_Crud] PRIMARY KEY CLUSTERED 
(
	[CrudId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MssToken]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MssToken](
	[Id] [int] NOT NULL,
	[GrantedTo] [varchar](100) NOT NULL,
	[CurrentToken] [varchar](max) NOT NULL,
	[RotativeToken] [varchar](max) NOT NULL,
	[MssSecretID] [varchar](100) NULL,
	[TokenValidFrom] [datetime] NOT NULL,
	[TokenValidTo] [datetime] NOT NULL,
	[ClientId] [varchar](100) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Role]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Role](
	[RoleId] [uniqueidentifier] NOT NULL,
	[RoleName] [varchar](50) NOT NULL,
	[RoleDescription] [varchar](500) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedById] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedById] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedById] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sysdiagrams]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysdiagrams](
	[name] [nvarchar](128) NOT NULL,
	[principal_id] [int] NOT NULL,
	[diagram_id] [int] NOT NULL,
	[version] [int] NULL,
	[definition] [varbinary](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Token]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Token](
	[Id] [uniqueidentifier] NOT NULL,
	[GrantedTo] [varchar](100) NOT NULL,
	[CurrentToken] [varchar](max) NOT NULL,
	[RotativeToken] [varchar](max) NOT NULL,
	[MssSecretID] [varchar](100) NULL,
	[TokenValidFrom] [datetime] NOT NULL,
	[TokenValidTo] [datetime] NOT NULL,
	[ClientId] [varchar](100) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAccessMatrix]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAccessMatrix](
	[UserAccessMatrixId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[UserAttributeId] [uniqueidentifier] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[UserAccessDescription] [varchar](400) NULL,
	[CreatedById] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedById] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedById] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_UserAccessMatrix] PRIMARY KEY CLUSTERED 
(
	[UserAccessMatrixId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAttributes]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAttributes](
	[UserAttributeId] [uniqueidentifier] NOT NULL,
	[UserAttributeName] [varchar](100) NOT NULL,
	[UserAttributeDescription] [varchar](400) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[AttributeId] [uniqueidentifier] NOT NULL,
	[CreatedById] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedById] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedById] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
	[CrudIds] [varchar](200) NOT NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_UserAttribute] PRIMARY KEY CLUSTERED 
(
	[UserAttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserAudit]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserAudit](
	[UserAuditId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserIP] [varchar](20) NOT NULL,
	[SuccessLoginDate] [datetime] NULL,
	[FailedLoginDate] [datetime] NULL,
	[SuccessLogoffDate] [datetime] NULL,
	[LockedDate] [datetime] NULL,
	[UnlockedDate] [datetime] NULL,
	[UserAuditDescription] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserGroup]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserGroup](
	[UserGroupID] [uniqueidentifier] NOT NULL,
	[UserGroupName] [nchar](100) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedByID] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedById] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedById] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_UserGroup] PRIMARY KEY CLUSTERED 
(
	[UserGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserGroup_User]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserGroup_User](
	[UserGroup_UserID] [uniqueidentifier] NOT NULL,
	[UserGroupID] [uniqueidentifier] NOT NULL,
	[UserID] [uniqueidentifier] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedBy] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_UserGroupID_UserID] PRIMARY KEY CLUSTERED 
(
	[UserGroupID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserInRole]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserInRole](
	[UserInRoleId] [uniqueidentifier] NULL,
	[UserId] [uniqueidentifier] NULL,
	[RoleId] [uniqueidentifier] NULL,
	[CreatedById] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedById] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [bit] NOT NULL,
	[DeletedById] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 17-10-2023 21:25:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [varchar](100) NOT NULL,
	[Password] [varchar](max) NULL,
	[FirstName] [varchar](200) NOT NULL,
	[Initials] [varchar](20) NULL,
	[LastName] [varchar](200) NULL,
	[Location] [varchar](200) NULL,
	[UserEmail] [varchar](200) NULL,
	[PhoneNumber] [varchar](20) NULL,
	[IsActive] [bit] NOT NULL,
	[InactiveDate] [datetime] NULL,
	[InactiveReason] [varchar](400) NULL,
	[IsUserLocked] [bit] NULL,
	[UnsuccessfullCount] [int] NULL,
	[WorkForIds] [varchar](max) NULL,
	[DefaultAttributeIds] [varchar](max) NULL,
	[MugShot] [varbinary](max) NULL,
	[Gender] [varchar](50) NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[DeletedBy] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
	[JobTitle] [varchar](200) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [IX_AttributeCategories]    Script Date: 17-10-2023 21:25:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_AttributeCategories] ON [dbo].[AttributeCategories]
(
	[AttributeCategoryName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Attributes]    Script Date: 17-10-2023 21:25:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Attributes] ON [dbo].[Attributes]
(
	[AttributePath] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Role]    Script Date: 17-10-2023 21:25:33 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Role] ON [dbo].[Role]
(
	[RoleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AttributeCategories] ADD  CONSTRAINT [DF_Table_1_AttributeId]  DEFAULT (newid()) FOR [AttributeCategoryId]
GO
ALTER TABLE [dbo].[Attributes] ADD  CONSTRAINT [DF_Attributes_AttributeId]  DEFAULT (newid()) FOR [AttributeId]
GO
ALTER TABLE [dbo].[Attributes] ADD  CONSTRAINT [DF_Attributes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Attributes] ADD  CONSTRAINT [DF_Attributes_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Attributes] ADD  CONSTRAINT [DF_Attributes_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Crud] ADD  CONSTRAINT [DF_Crud_CrudId]  DEFAULT (newid()) FOR [CrudId]
GO
ALTER TABLE [dbo].[Role] ADD  CONSTRAINT [DF_Role_RoleId]  DEFAULT (newid()) FOR [RoleId]
GO
ALTER TABLE [dbo].[Role] ADD  CONSTRAINT [DF_Role_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Role] ADD  CONSTRAINT [DF_Role_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Role] ADD  CONSTRAINT [DF_Role_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Token] ADD  CONSTRAINT [DF_Token_Id]  DEFAULT (newid()) FOR [Id]
GO
ALTER TABLE [dbo].[Token] ADD  CONSTRAINT [DF_Token_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[UserAccessMatrix] ADD  DEFAULT (newid()) FOR [UserAccessMatrixId]
GO
ALTER TABLE [dbo].[UserAccessMatrix] ADD  CONSTRAINT [DF_UserAccessMatrix_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[UserAccessMatrix] ADD  CONSTRAINT [DF_UserAccessMatrix_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[UserAccessMatrix] ADD  CONSTRAINT [DF_UserAccessMatrix_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[UserAttributes] ADD  CONSTRAINT [DF_UserAttributes_UserAttributeId]  DEFAULT (newid()) FOR [UserAttributeId]
GO
ALTER TABLE [dbo].[UserAttributes] ADD  CONSTRAINT [DF_UserAttributes_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[UserAttributes] ADD  CONSTRAINT [DF_UserAttributes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[UserAttributes] ADD  CONSTRAINT [DF_UserAttributes_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[UserAudit] ADD  CONSTRAINT [DF_UserAudit_UserAuditId]  DEFAULT (newid()) FOR [UserAuditId]
GO
ALTER TABLE [dbo].[UserGroup] ADD  CONSTRAINT [DF_UserGroup_UserGroupID]  DEFAULT (newid()) FOR [UserGroupID]
GO
ALTER TABLE [dbo].[UserGroup] ADD  CONSTRAINT [DF_UserGroup_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[UserGroup] ADD  CONSTRAINT [DF_UserGroup_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[UserGroup_User] ADD  CONSTRAINT [DF_UserGroup_User_UserGroup_UserID]  DEFAULT (newid()) FOR [UserGroup_UserID]
GO
ALTER TABLE [dbo].[UserGroup_User] ADD  CONSTRAINT [DF_UserGroup_User_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[UserGroup_User] ADD  CONSTRAINT [DF_UserGroup_User_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[UserGroup_User] ADD  CONSTRAINT [DF_UserGroup_User_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[UserInRole] ADD  CONSTRAINT [DF_UserInRole_UserInRoleId]  DEFAULT (newid()) FOR [UserInRoleId]
GO
ALTER TABLE [dbo].[UserInRole] ADD  CONSTRAINT [DF_UserInRole_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[UserInRole] ADD  CONSTRAINT [DF_UserInRole_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[UserInRole] ADD  CONSTRAINT [DF_UserInRole_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_UserId]  DEFAULT (newid()) FOR [UserId]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_UnsuccessfullCount]  DEFAULT ((0)) FOR [UnsuccessfullCount]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[UserAccessMatrix]  WITH CHECK ADD  CONSTRAINT [FK_UserAccessMatrix_Role] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleId])
GO
ALTER TABLE [dbo].[UserAccessMatrix] CHECK CONSTRAINT [FK_UserAccessMatrix_Role]
GO
ALTER TABLE [dbo].[UserAccessMatrix]  WITH CHECK ADD  CONSTRAINT [FK_UserAccessMatrix_UserAttributes] FOREIGN KEY([UserAttributeId])
REFERENCES [dbo].[UserAttributes] ([UserAttributeId])
GO
ALTER TABLE [dbo].[UserAccessMatrix] CHECK CONSTRAINT [FK_UserAccessMatrix_UserAttributes]
GO
ALTER TABLE [dbo].[UserAttributes]  WITH CHECK ADD  CONSTRAINT [FK_UserAttributes_Attributes] FOREIGN KEY([AttributeId])
REFERENCES [dbo].[Attributes] ([AttributeId])
GO
ALTER TABLE [dbo].[UserAttributes] CHECK CONSTRAINT [FK_UserAttributes_Attributes]
GO
ALTER TABLE [dbo].[UserGroup_User]  WITH CHECK ADD  CONSTRAINT [FK_UserGroup_User_UserGroup] FOREIGN KEY([UserGroupID])
REFERENCES [dbo].[UserGroup] ([UserGroupID])
GO
ALTER TABLE [dbo].[UserGroup_User] CHECK CONSTRAINT [FK_UserGroup_User_UserGroup]
GO
ALTER TABLE [dbo].[UserGroup_User]  WITH CHECK ADD  CONSTRAINT [FK_UserGroup_User_Users] FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UserGroup_User] CHECK CONSTRAINT [FK_UserGroup_User_Users]
GO
ALTER TABLE [dbo].[UserInRole]  WITH CHECK ADD  CONSTRAINT [FK_UserInRole_Role] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleId])
GO
ALTER TABLE [dbo].[UserInRole] CHECK CONSTRAINT [FK_UserInRole_Role]
GO
ALTER TABLE [dbo].[UserInRole]  WITH CHECK ADD  CONSTRAINT [FK_UserInRole_Users] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
ALTER TABLE [dbo].[UserInRole] CHECK CONSTRAINT [FK_UserInRole_Users]
GO
/****** Object:  StoredProcedure [dbo].[spCheckUser]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spCheckUser]
(
	@Username VARCHAR(100),
	@UserIP VARCHAR(10)
)
AS
BEGIN

--spCheckUser "test_user","12345"

DECLARE @IsActive BIT = 0;
DECLARE @CurrentUserId UNIQUEIDENTIFIER;
DECLARE @IsUserLocked BIT = 0;
DECLARE @IsValidUser BIT = 0;
DECLARE @ErrorMessage VARCHAR(250);
DECLARE @IsError BIT = 0;
DECLARE @ErrorId INT = 0; 

BEGIN TRY

	IF EXISTS(SELECT * FROM Users WHERE UserName = @Username AND IsDeleted != 1)
		BEGIN
		
			SET @IsValidUser = 1
			SET @ErrorMessage = 'Valid user';

			 SELECT @IsActive = ISNULL(IsActive,0), @IsUserLocked = ISNULL(IsUserLocked, 0), @CurrentUserId = UserId 
			 FROM Users WHERE UserName = @UserName;

			 IF(@IsUserLocked=1)
				 BEGIN
					SET @IsValidUser = 0;
					SET @ErrorMessage = 'User has been locked, please contact administrator.';
				 END
			 ELSE IF(@IsActive=0)
				BEGIN
					SET @IsValidUser = 0;
					SET @ErrorMessage = 'User is inactive, please contact administrator.'
				END
			 
			INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, FailedLoginDate , SuccessLogoffDate , UserAuditDescription)
			VALUES(@CurrentUserId, @UserIP, NULL, GETDATE(), NULL, Concat('User ', @UserName, ' exists.'));

			SELECT UserId, UserName,
			 CASE
				WHEN @IsValidUser = 1 THEN Password
				ELSE NULL
			 END AS Password,
			IsActive, @IsValidUser As IsValidUser,0 AS ErrorId, @IsError AS IsError,  @ErrorMessage AS ErrorMessage,  @ErrorMessage AS ValidateResponse,
			@IsUserLocked AS IsUserLocked
			FROM Users
			WHERE UserName = @UserName AND (IsDeleted IS NULL OR IsDeleted = 0);
				
		END
	ELSE
		BEGIN
			SET @IsValidUser = 0

			INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, FailedLoginDate , SuccessLogoffDate , UserAuditDescription)
			VALUES(CAST(0x0 AS UNIQUEIDENTIFIER), @UserIP, NULL, GETDATE(), NULL, 'User does not exist.');
			
			SELECT CAST(0x0 AS UNIQUEIDENTIFIER) AS UserId, @UserName AS UserName, NULL AS Password, @IsActive AS IsActive, @IsValidUser As IsValidUser,
			 0 AS ErrorId, @IsError AS IsError, NULL AS ErrorMessage,'User does not exists<br/>Please contact Administrator to create an account' AS ValidateResponse,
			@IsUserLocked AS IsUserLocked
		END

--spCheckUser "test_user","12345"
END TRY

BEGIN CATCH
	SET @IsValidUser	=	0
	SET @IsError		=	1

	SELECT CAST(0x0 AS UNIQUEIDENTIFIER) AS UserId, NULL AS UserName, NULL AS Password, 0 AS IsActive, @IsValidUser As IsValidUser,
	ERROR_NUMBER() AS ErrorId,  @IsError AS IsError,  ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse,
	@IsUserLocked AS IsUserLocked 

END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[spCheckUserAccess]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spCheckUserAccess]
(
	@AccessedById	UNIQUEIDENTIFIER,
	@AttributePath	VARCHAR(100),
	@CrudName		VARCHAR(10) = NULL
)
AS
BEGIN

	-- spCheckUserAccess '0FA9B4E3-9556-4E3A-AAA9-5885B3FDAB13','/test'
	BEGIN TRY

	DECLARE @IsError			BIT = 0;
	DECLARE @SARoleName			VARCHAR(50) = 'SAdmin';
	DECLARE @AllAccess			VARCHAR(100);
	DECLARE @AllAccessCount		INT = 0;
	DECLARE @DefaultAttrTable	TABLE 
    ( 
        AttributeId   UNIQUEIDENTIFIER,
        CrudIds           VARCHAR(MAX)
    )
	DECLARE @DfltCrudIds		VARCHAR(100);
	DECLARE @AllAccess_DA		VARCHAR(100);
	DECLARE @AllAccessCount_DA	INT = 0;
	DECLARE @JoinedCN           VARCHAR(MAX);
	DECLARE @CID                UNIQUEIDENTIFIER = NULL;



	SELECT @AllAccess = STRING_AGG(CrudName, ',') FROM Crud;
	SET @AllAccess = COALESCE(@AllAccess, '');

	SELECT @AllAccessCount = COUNT(*) FROM Crud

    SELECT @CID= CrudId FROM Crud WHERE CrudName = @CrudName;

	IF [dbo].[CheckUserSAdmin](@AccessedById) = 1 
		BEGIN
			 SELECT @AllAccessCount AS TotalAccessCount, @AllAccess AS AccessLevels,
            -1 AS ErrorId, @IsError AS IsError, 
            'No error' As ErrorMessage, 
            'No error in checking user access' AS ValidateResponse
		END
	ELSE
		BEGIN
			INSERT INTO @DefaultAttrTable
			SELECT AttributeId, CrudIds FROM UserAttributes 
			WHERE UserAttributeId IN 
			(
				SELECT Value
				FROM STRING_SPLIT(
					(
						SELECT IIF(LTRIM(RTRIM(DefaultAttributeIds)) = '', NULL, DefaultAttributeIds)
						FROM Users
						WHERE UserId = @AccessedById AND IsActive = 1
					),
					','
				)
			);

			IF EXISTS(SELECT TOP 1 * FROM @DefaultAttrTable)
				BEGIN

					SELECT @DfltCrudIds = CrudIds FROM @DefaultAttrTable 
					WHERE AttributeId IN 
					( 
						SELECT AttributeId FROM Attributes
						WHERE AttributeName = @AttributePath
						AND IsActive = 1 AND IsDeleted = 0
					);

					
					SELECT @AllAccess_DA = STRING_AGG(CrudName, ', ') 
					FROM Crud 
					WHERE CrudId IN (SELECT VALUE FROM STRING_SPLIT(@DfltCrudIds, ','))
					AND (@CID IS NULL OR @CID IN (SELECT VALUE FROM STRING_SPLIT(@DfltCrudIds, ',')))


					SELECT @AllAccessCount_DA = COUNT(*) FROM STRING_SPLIT(@DfltCrudIds, ',');


					SELECT @AllAccessCount_DA AS TotalAccessCount, @AllAccess_DA AS AccessLevels,
					-1 AS ErrorId, @IsError AS IsError, 
					'No error' As ErrorMessage, 
					'No error in checking user access' AS ValidateResponse

				END

			ELSE
				BEGIN

					DECLARE @CurrentUserRoleId UNIQUEIDENTIFIER;

					SELECT @CurrentUserRoleId = RoleId
					FROM UserInRole
					WHERE UserId = @AccessedById;

					WITH FilteredAttributes AS (
						SELECT UA.AttributeId, UA.CrudIds, A.AttributePath
						FROM UserAttributes UA
						LEFT JOIN Attributes A ON UA.AttributeId = A.AttributeId
						WHERE EXISTS (
							SELECT 1
							FROM Attributes
							WHERE AttributeId = UA.AttributeId
							AND AttributePath = @AttributePath
							AND IsActive = 1
							AND IsDeleted = 0
						)
						AND EXISTS (
							SELECT 1
							FROM UserAccessMatrix
							WHERE IsActive = 1
							AND RoleId = @CurrentUserRoleId
							AND UserAttributeId = UA.UserAttributeId
						)
					)

					SELECT *
					INTO #TempTable
					FROM FilteredAttributes;


					SELECT DISTINCT
					t1.AttributePath,
					STUFF(
						(
							SELECT ',' + STUFF(
								(
									SELECT ',' + CT.CrudName
									FROM Crud AS CT
									WHERE CT.CrudId IN (SELECT Value FROM STRING_SPLIT(t2.CrudIds, ','))
									AND (@CID IS NULL OR @CID IN (SELECT VALUE FROM STRING_SPLIT(t2.CrudIds, ',')))
									FOR XML PATH('')
								), 1, 1, ''
							)
							FROM #TempTable AS t2
							WHERE t2.AttributePath = t1.AttributePath
							FOR XML PATH('')
						), 1, 1, ''
					) AS JoinedCN
					INTO #TempTable2
					FROM #TempTable AS t1;

				SELECT @JoinedCN = JoinedCN FROM #TempTable2;

				IF @JoinedCN IS NOT NULL
					BEGIN

						SELECT 0 AS AccessCount, count(*) AS TotalAccessCount, IIF(@JoinedCN IS NULL, '', @JoinedCN) AS AccessLevels,
						-1 AS ErrorId, @IsError AS IsError, 
						'No error' As ErrorMessage, 
						'No error in checking user access' AS ValidateResponse

					END
				ELSE 
					BEGIN
						
						SELECT 0 AS AccessCount, 0 AS TotalAccessCount, '' AS AccessLevels,
						-1 AS ErrorId, @IsError AS IsError, 
						'No error' As ErrorMessage, 
						'User does not have access!!!' AS ValidateResponse

					END
				
				
                                        

				END
			
			
		END

		-- spCheckUserAccess '8ABC7E7E-5316-4F79-8FA0-884D7FD804C7','/test-path121'

	END TRY

	BEGIN CATCH
		SET @IsError = 1;
		SELECT 0 AS AccessCount, 0 As TotalAccessCount, '' AS AccessLevels,
		-1 AS ErrorId, 
		@IsError AS IsError, 
		ERROR_MESSAGE() As ErrorMessage, 
		ERROR_MESSAGE() AS ValidateResponse	
	END CATCH
END

GO
/****** Object:  StoredProcedure [dbo].[spCreateTokenInDB]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spCreateTokenInDB]   
(  
	@GrantedTo		    VARCHAR(max),
	@CurrentToken	    VARCHAR(max),
    @RotativeToken	    VARCHAR(max),
	@TokenValidFrom     DATETIME,
	@TokenValidTo		DATETIME,
	@ClientID		    VARCHAR(100)
)  
AS
BEGIN  
  
  	DECLARE @TokenID UNIQUEIDENTIFIER;
	SET @TokenID = NEWID();

	UPDATE Token SET IsDeleted = 1 WHERE GrantedTo = @GrantedTo AND IsDeleted = 0
	INSERT INTO [dbo].[Token](
		[Id], [GrantedTo], [CurrentToken], [RotativeToken], [TokenValidFrom], [TokenValidTo], [ClientID], [CreatedDate]
	)
	VALUES(
		@TokenID, @GrantedTo, @CurrentToken, @RotativeToken, @TokenValidFrom, @TokenValidTo, @ClientID, GETDATE()
	);


	SELECT TOP (1) [ID]
      ,[GrantedTo]
      ,[CurrentToken]
      ,[RotativeToken]
      ,[MssSecretID]
	  ,[TokenValidFrom]
	  ,[TokenValidTo]
	  ,[ClientID]
      ,[CreatedDate]
	FROM [dbo].[Token] WHERE [ID] = @TokenID AND [IsDeleted] = 0;

    
END  
GO
/****** Object:  StoredProcedure [dbo].[spDeleteAttribute]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spDeleteAttribute]
(  
    @AttributeId UniqueIdentifier,
	@DeletedById UniqueIdentifier
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
    SET NOCOUNT ON;  
    DECLARE @IsError BIT = 0  
    BEGIN TRY  
        IF  EXISTS(SELECT 1 FROM UserAttributes WHERE AttributeId = @AttributeId AND IsActive = 1 AND IsDeleted = 0) 
        BEGIN  
            SET @IsError = 1;   
            SELECT -1 AS ErrorId, @IsError AS IsError, 'CANNOT DELETE! Attribute is assigned in Attribute-Access' AS ErrorMessage, 'CANNOT DELETE! Attribute is assigned in Attribute-Access' AS ValidateResponse
        END  
        ELSE
        BEGIN
            IF  EXISTS(SELECT 1 FROM Attributes WHERE AttributeId = @AttributeId) 
            BEGIN  
                UPDATE Attributes SET IsActive = 0, IsDeleted = 1, DeletedById = @DeletedById, DeletedDate = GETDATE() WHERE AttributeId= @AttributeId

                SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'Attribute deleted sucessfully' AS ValidateResponse
        
            END  
            ELSE
            BEGIN
                SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'Attribute not found' AS ValidateResponse
                
            END
        END
    
    END TRY  
        
    BEGIN CATCH  

        SET @IsError = 1;   
        SELECT CONVERT(Varchar,  ERROR_NUMBER()) AS ErrorId, @IsError AS IsError, 
        ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
        
    END CATCH  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[spDeleteRole]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================  
-- Author:  <Author,,Name>  
-- Create date: <Create Date,,>  
-- Description: <Description,,>  
-- =============================================  
CREATE   PROCEDURE [dbo].[spDeleteRole]
(  
    @RoleId     UniqueIdentifier,
    @ModifiedById  UNIQUEIDENTIFIER
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
 
 DECLARE @IsError  BIT  = 0  

  
 BEGIN TRY  
 
   IF EXISTS(SELECT 1 FROM Role WHERE RoleId=@RoleId)
   BEGIN  
		UPDATE Role SET IsActive = 0, IsDeleted = 1, DeletedById=@ModifiedById,DeletedDate=GETDATE()
		 WHERE RoleId= @RoleId
		
	SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'Role deleted sucessfully' AS ValidateResponse;
 
   END  
  ELSE
    BEGIN
		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'Role not found' AS ValidateResponse  
	END

  
 END TRY  
      
 BEGIN CATCH  
  
  SET @IsError = 1;   
  SELECT CONVERT(Varchar,  ERROR_NUMBER()) AS ErrorId, @IsError AS IsError, 
  ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
      
 END CATCH  
  
END  

GO
/****** Object:  StoredProcedure [dbo].[spDeleteUser]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spDeleteUser]
(  
    @UserId         UNIQUEIDENTIFIER,
    @ModifiedById   UNIQUEIDENTIFIER
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
    SET NOCOUNT ON;  

    DECLARE @IsError  BIT  = 0  
  
    BEGIN TRY  

    IF  EXISTS(SELECT 1 FROM Users WHERE UserId= @UserId)
    BEGIN  

        UPDATE Users SET IsActive = 0, IsDeleted = 1, DeletedBy = @ModifiedById, DeletedDate = GETDATE()
        WHERE UserId= @UserId
        
        SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User deleted sucessfully' AS ValidateResponse  

    END  
    ELSE
    BEGIN

        SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User not found' AS ValidateResponse

    END

    END TRY  
      
    BEGIN CATCH  
  
        SET @IsError = 1;   
        SELECT CONVERT(Varchar,  ERROR_NUMBER()) AS ErrorId, @IsError AS IsError, 
        ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
      
    END Catch  
  
END  

GO
/****** Object:  StoredProcedure [dbo].[spDeleteUserAccessMatrix]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spDeleteUserAccessMatrix]
(  
    @UserAccessMatrixId UNIQUEIDENTIFIER,
    @ModifiedById  UNIQUEIDENTIFIER
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
 
 DECLARE @IsError  BIT  = 0  

  
 BEGIN TRY  
 
    IF  EXISTS(SELECT 1 FROM dbo.UserAccessMatrix WHERE UserAccessMatrixId = @UserAccessMatrixId)
        BEGIN  
                UPDATE dbo.UserAccessMatrix SET IsActive = 0,IsDeleted = 1, DeletedById=@ModifiedById, DeletedDate=GETDATE()
                WHERE UserAccessMatrixId= @UserAccessMatrixId
                
                SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User Matrix is deleted sucessfully' AS ValidateResponse
        END
    ELSE
    BEGIN
		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User Matrix not found' AS ValidateResponse
	END

 END TRY  
 BEGIN CATCH  
  
    SET @IsError = 1;   
    SELECT CONVERT(Varchar,  ERROR_NUMBER()) AS ErrorId, @IsError AS IsError, 
    ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
      
 END CATCH  
  
END  

GO
/****** Object:  StoredProcedure [dbo].[spDeleteUserAttribute]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spDeleteUserAttribute]  
(    
    @UserAttributeId UNIQUEIDENTIFIER,  
    @ModifiedById  UNIQUEIDENTIFIER  
)    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
   
 DECLARE @IsError  BIT  = 0    
    
 BEGIN TRY   
	BEGIN TRANSACTION
    IF EXISTS (SELECT 1 FROM dbo.UserAccessMatrix WHERE UserAttributeId= @UserAttributeId AND IsActive = 1 AND IsDeleted=0)  
    BEGIN  

        SET @IsError = 1;
        SELECT -1 AS ErrorId, @IsError as IsError, 'CANNOT DELETE! Attribute-Access is assigned in User Access Matrix' AS ErrorMessage, 'CANNOT DELETE! Attribute-Access is assigned in Role Access Matrix' AS ValidateResponse

    END    
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM UserAttributes WHERE UserAttributeId= @UserAttributeId)  
        BEGIN  

			DELETE FROM UserAccessMatrix WHERE UserAttributeId = @UserAttributeId;

			DELETE FROM UserAttributes WHERE UserAttributeId = @UserAttributeId;

            SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User Attribute deleted sucessfully' AS ValidateResponse

        END    
        ELSE  
        BEGIN  
            SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User Attribute not found' AS ValidateResponse
        END  
    END
    COMMIT TRANSACTION
 END TRY    
        
 BEGIN CATCH    
    ROLLBACK TRANSACTION
    SET @IsError = 1;     
    SELECT CONVERT(Varchar,  ERROR_NUMBER()) AS ErrorId, @IsError AS IsError,   
    ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
        
 END CATCH    
    
END 
GO
/****** Object:  StoredProcedure [dbo].[spGetAllRoles]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spGetAllRoles]
(
	@AccessedById   UNIQUEIDENTIFIER
)
AS
BEGIN
	--select * from users
	--SELECT * FROM ROLE
	--spGetRole '8ABC7E7E-5316-4F79-8FA0-884D7FD804C7'
	SET NOCOUNT ON;
	DECLARE @IsError BIT = 0  
	DECLARE @IsSAdmin  BIT = 0;
	BEGIN TRY
		
		SET @IsSAdmin = [dbo].[CheckUserSAdmin](@AccessedById);

		SELECT R.[RoleId]
		,R.[RoleName]
		,R.[RoleDescription]
		,R.[IsActive]
		,R.[CreatedById]
		,R.[CreatedDate]
		,R.[ModifiedById]
		,R.[ModifiedDate]
		,R.[DeletedById]
		,R.[DeletedDate]
		,CONCAT(U.FIRSTNAME, ' ', U.LastName ) AS CreatedBy
		,CONCAT(U.FIRSTNAME, ' ', U.LastName ) AS ModifiedBy
		FROM [dbo].[Role] R 
		LEFT JOIN Users U on R.CreatedById = U.UserId
		WHERE R.IsDeleted = 0
		AND @IsSAdmin = 1 OR ( @IsSAdmin = 0 AND RoleName <> 'SAdmin')
		ORDER BY R.RoleName ASC

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'Operation Successful' AS ValidateResponse;

	END TRY
	BEGIN CATCH

		SET @IsError = 1; 
        SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse;

	END CATCH
	
END
GO
/****** Object:  StoredProcedure [dbo].[spGetAllUsers]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spGetAllUsers] 
(
    @UserId		UNIQUEIDENTIFIER
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @UnSuccessfulCount		INT = 0;
	DECLARE @UnSuccessfulTotalCount INT = 0;
	DECLARE @CurrentUserId			UniqueIdentifier;
	DECLARE @ValidateMessage		VARCHAR(200)	= ''
	DECLARE @IsActive				BIT				= 0; 
	DECLARE @IsUserLocked			BIT				= 0; 
	DECLARE @IsError				BIT				= 0;
	DECLARE @IsLoginFailed			BIT				= 0;
	DECLARE	@IsLogOff				BIT				= 0			
	DECLARE	@IsUserAcceptance		BIT				= 0			
	DECLARE @IsValidUser			BIT				= 0


        SELECT DISTINCT CONVERT(VARCHAR(MAX), UserId) AS UserId ,
        STUFF((Select ','+ CONVERT(VARCHAR(MAX), UR1.RoleId) 
        FROM UserInRole UR1
        LEFT JOIN Role R ON UR1.RoleId = R.RoleId
        WHERE UR1.IsActive = 1 AND R.IsActive = 1
        AND  UR1.UserId = UR2.UserId
        FOR XML PATH('')),1,1,'') AS RoleIds
        INTO #TempUserInRole
        FROM UserInRole UR2

		SELECT USR.UserId
		, USR.UserName
		, NULL AS Password
		, USR.FirstName
		, USR.Initials
		, USR.LastName
		, CONCAT(USR.FirstName,USR.LastName) AS FullName
		, USR.UserEmail
		, USR.PhoneNumber
		, USR.InactiveDate
		, USR.InactiveReason
		, USR.JobTitle
		, USR.IsUserLocked
		, -1 AS UnsuccessfulCount
		, NULL AS WorkIds
		, USR.Gender
		, USR.IsActive, 
		IsNull(UIR.RoleIds,'00000000-0000-0000-0000-000000000000') As RoleIds
		, USR.Location
		, USR.MugShot
		, USR.DefaultAttributeIds
		, USR.CreatedBy
		, USR.CreatedDate
		, USR.ModifiedBy
		, USR.ModifiedDate
		, USR.IsDeleted
		, USR.DeletedBy
		, USR.DeletedDate
		, USR.JobTitle
		FROM		Users			USR
		LEFT JOIN	#TempUserInRole	UIR		ON USR.UserId = UIR.UserId
		WHERE USR.UserId = IIF(@UserId IS NULL OR LEN(LTRIM(RTRIM(@UserId))) = 0, USR.UserId, @UserId)
        AND IsDeleted = 0 AND IsActive = 1
   		ORDER BY USR.FirstName, USR.LastName 
		
END

GO
/****** Object:  StoredProcedure [dbo].[spGetAttributes]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spGetAttributes]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT  AttributeId
      ,AttributeName
	  ,AttributePath
      ,A.IsComponent
      ,A.CreatedById
      ,A.CreatedDate
      ,A.ModifiedById
      ,A.ModifiedDate
      ,A.IsActive
	  ,CONCAT(U.FIRSTNAME, ' ', U.LastName ) AS CreatedBy
	  ,CONCAT(US.FIRSTNAME, ' ', US.LastName ) AS ModifiedBy
	  FROM Attributes A LEFT JOIN Users U on
	  A.CreatedById=U.UserId
	  LEFT JOIN Users US on A.CreatedById=US.UserId
	  WHERE A.IsActive = 1 AND A.IsDeleted = 0

	  --SELECT * FROM ATTRIBUTES
END

GO
/****** Object:  StoredProcedure [dbo].[spGetTokenByTokenID]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spGetTokenByTokenID] 
(    
  @TokenID  UNIQUEIDENTIFIER
)    
AS    

BEGIN
    
	SELECT TOP (1) [ID]
      ,[GrantedTo]
      ,[CurrentToken]
      ,[RotativeToken]
      ,[MssSecretID]
	  ,[TokenValidFrom]
	  ,[TokenValidTo]
	  ,[ClientID]
      ,[CreatedDate]
	FROM [dbo].[Token] WHERE [ID] = @TokenID AND (IsDeleted IS NULL OR IsDeleted = 0);

END 
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAccessMatrix]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spGetUserAccessMatrix]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT   statements.
	SET NOCOUNT ON;

	Declare  @temp table(
        [userAccessMatrixId] [uniqueidentifier]  NULL,
        [roleId] [uniqueidentifier] NULL,
        [roleName] [varchar](50) NULL,
        [isActive] [bit] NULL,   
        [userAttributeId] [uniqueidentifier]  NULL, 
        [userAttributeName] [varchar](50) NULL,
        [attributePath] [varchar](50) NULL,
        [crudIds] [varchar](200) NULL,
        [attributeAccessList] [varchar](MAX) NULL,
        [createdById] [uniqueidentifier] NULL,  
        [createdDate] [datetime] NULL ,  
        [modifiedById] [uniqueidentifier] NULL,  
        [modifiedDate] [datetime] NULL,  
        [createdBy] varchar(500) NULL,  
        [modifiedBy] varchar(500) NULL,   
		ID int 
    )   
	 
	INSERT INTO @temp SELECT 
        umx.UserAccessMatrixId
        ,umx.RoleId
        ,r.RoleName
        ,r.IsActive
        ,ua.UserAttributeId
        ,ua.UserAttributeName
        ,a.AttributePath
        ,ua.CrudIds
        ,(SELECT ua.UserAttributeId AS 'userAttributeId', ua.AttributeId AS 'attributeId', cm.CrudId AS crudId, cm.CrudName AS crudName FROM Crud cm 
                WHERE cm.CrudId IN (SELECT Value FROM STRING_SPLIT( UA.CrudIds, ',')) 
                FOR JSON AUTO) AS AttributeAccessList
        ,umx.CreatedById
        ,umx.CreatedDate
        ,umx.ModifiedById
        ,umx.ModifiedDate
        ,CONCAT(uc.FIRSTNAME, ' ', uc.LastName ) AS CreatedBy
        ,CONCAT(um.FIRSTNAME, ' ', um.LastName ) AS ModifiedBy
        ,ROW_NUMBER() OVER(PARTITION BY umx.RoleId   
                               ORDER BY umx.[CreatedDate] DESC ) AS rk
        FROM UserAccessMatrix umx
        LEFT JOIN Role r on umx.RoleId=r.RoleId
        LEFT JOIN UserAttributes ua on umx.userAttributeId=ua.userAttributeId
        LEFT JOIN Attributes a on ua.AttributeId=a.AttributeId
        LEFT JOIN users uc on umx.CreatedById=uc.UserId
        LEFT JOIN users um on umx.ModifiedById=um.UserId
        WHERE umx.IsActive = 1 AND umx.IsDeleted = 0;

		WITH summary AS (
		 SELECT umx.UserAccessMatrixId
          ,umx.UserAccessDescription
          ,umx.RoleId
          ,r.RoleName
	      ,umx.[CreatedById]
	      ,umx.[CreatedDate]
	      ,umx.[ModifiedById]
	      ,umx.[ModifiedDate]
	      ,umx.IsActive
	     ,CONCAT(uc.FIRSTNAME, ' ', uc.LastName ) AS CreatedBy
	     ,CONCAT(um.FIRSTNAME, ' ', um.LastName ) AS ModifiedBy
         ,(SELECT * FROM @temp t 
		 where 
		 t.roleId = umx.RoleId 
         -- and t.id=1
		  for json auto) as 'UserAttributeDetails'
        ,ROW_NUMBER() OVER(PARTITION BY umx.RoleId   
	                                 ORDER BY umx.[CreatedDate] DESC) AS rk
	  	FROM UserAccessMatrix	umx
	  	INNER JOIN [Role]		r		on r.RoleId			= umx.RoleId
	   	LEFT JOIN users			uc		on umx.CreatedById	= uc.UserId
		LEFT JOIN users			um		on umx.ModifiedById	= um.UserId
        WHERE Upper(umx.UserAccessMatrixId) IN (SELECT upper(userAccessMatrixId) FROM @temp)
   	)

   	SELECT  UserAccessMatrixId
      ,[CreatedById]
      ,[CreatedDate]
      ,[ModifiedById]
      ,[ModifiedDate]
      ,IsActive
     , CreatedBy
     , ModifiedBy
     , RoleId
  	 , RoleName
 	 ,UserAttributeDetails 
	 From summary s 
	 Where s.rk = 1
END


GO
/****** Object:  StoredProcedure [dbo].[spGetUserAttrributes]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spGetUserAttrributes]  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
    SET NOCOUNT ON;
    SELECT UserAttributeId
	, UserAttributeName
	, UserAttributeDescription
	, UA.AttributeId
    , A.AttributeName
	, A.AttributePath
	, CrudIds
    , UA.CreatedById
	, UA.CreatedDate
	, UA.ModifiedById
	, UA.ModifiedDate
    , (SELECT ua.UserAttributeId AS 'userAttributeId', ua.AttributeId AS 'attributeId', cm.CrudId AS crudId, cm.CrudName AS crudName FROM Crud cm 
            WHERE cm.CrudId IN (SELECT Value FROM STRING_SPLIT( UA.CrudIds, ',')) 
			FOR JSON AUTO) AS AttributeAccessList
    FROM UserAttributes UA  
    LEFT JOIN Attributes A ON UA.AttributeId = A.AttributeId
    WHERE UA.IsActive = 1 AND UA.IsDeleted = 0;
END 
GO
/****** Object:  StoredProcedure [dbo].[spGetUserDetails]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spGetUserDetails]
(
	@Username VARCHAR(100),
	@UserIP  VARCHAR(20)
)
AS
BEGIN
	
	DECLARE @SARoleName VARCHAR(50) = 'SAdmin';
	DECLARE @ISSA BIT = 0;
	DECLARE @CurrentUserId UNIQUEIDENTIFIER;
	DECLARE @IsError BIT = 0;
	
	BEGIN TRY

		SELECT @CurrentUserId = UserId FROM Users WHERE UserName = @Username;

		-- Log successfull login

		INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, FailedLoginDate , SuccessLogoffDate , UserAuditDescription)
					VALUES(@CurrentUserId, @UserIP, GETDATE(), NULL, NULL, 'Sucessful login');

		UPDATE Users SET UnsuccessfullCount = 0, IsUserLocked = 0 WHERE UserId = @CurrentUserId;

		-- Get role details

		Select Distinct CONVERT(VARCHAR(MAX), UserId) AS UserId,
		STUFF((Select ','+ CONVERT(VARCHAR(MAX), UR1.RoleId) 
		FROM UserInRole UR1
		LEFT JOIN Role R ON R.RoleId = UR1.RoleId
		WHERE UR1.UserId = UR2.UserId AND UR1.IsActive = 1 AND UR1.DeletedById IS NULL AND UR1.DeletedDate IS NULL 
		AND R.IsActive = 1 AND R.DeletedById IS NULL AND R.DeletedDate IS NULL
		FOR XML PATH('')),1,1,'') AS RoleId
		INTO #TempUserInRole
		FROM UserInRole UR2

		Select Distinct CONVERT(VARCHAR(MAX), UserId) AS UserId ,
		STUFF((Select ','+ CONVERT(VARCHAR(MAX), R.RoleName) 
		FROM UserInRole UR1
		LEFT JOIN Role R ON R.RoleId = UR1.RoleId
		WHERE UR1.UserId = UR2.UserId AND UR1.IsActive = 1 AND UR1.DeletedById IS NULL AND UR1.DeletedDate IS NULL 
		AND R.IsActive = 1 AND R.DeletedById IS NULL AND R.DeletedDate IS NULL
		FOR XML PATH('')),1,1,'') AS RoleNames
		INTO #TempUserInRole2
		FROM UserInRole UR2


		-- Get user group details

		Select Distinct CONVERT(VARCHAR(MAX), UserId) AS UserId,
		STUFF((Select ','+ CONVERT(VARCHAR(MAX), UG.UserGroupId) 
		FROM UserGroup_User UIUG1
		LEFT JOIN UserGroup UG ON UG.UserGroupId = UIUG1.UserGroupId
		WHERE UIUG1.UserId = UIUG2.UserId AND UIUG1.IsActive = 1 AND UIUG1.IsDeleted = 0 
		AND UG.IsActive = 1 AND UG.DeletedById IS NULL AND UG.DeletedDate IS NULL
		FOR XML PATH('')),1,1,'') AS GroupId
		INTO #TempUserInGroup
		FROM UserGroup_User UIUG2

		Select Distinct CONVERT(VARCHAR(MAX), UserId) AS UserId,
		STUFF((Select ','+ CONVERT(VARCHAR(MAX), UG.UserGroupName) 
		FROM UserGroup_User UIUG1
		LEFT JOIN UserGroup UG ON UG.UserGroupId = UIUG1.UserGroupId
		WHERE UIUG1.UserId = UIUG2.UserId AND UIUG1.IsActive = 1 AND UIUG1.IsDeleted = 0
		AND UG.IsActive = 1 AND UG.DeletedById IS NULL AND UG.DeletedDate IS NULL
		FOR XML PATH('')),1,1,'') AS GroupNames
		INTO #TempUserInGroup2
		FROM UserGroup_User UIUG2


		-- Check if Super admin

		IF EXISTS(
			SELECT 1 FROM Users U 
			INNER JOIN UserInRole UIR ON UIR.USERID = U.UserId
			INNER JOIN Role R ON R.RoleId = UIR.ROLEID
			WHERE UserName = @Username and RoleName = @SARoleName
		)

		BEGIN
			SET @ISSA = 1;
		END

		SELECT USR.UserId, USR.UserName, USR.FirstName, USR.Initials, USR.LastName, USR.JobTitle, 
		USR.UserEmail, ISNULL(USR.IsUserLocked, 0) AS  IsUserLocked, USR.IsActive, USR.InactiveDate, 
		USR.InactiveReason, 'Valid user' AS ValidateResponse, 
		0 AS ErrorId, @IsError AS IsError, NULL AS ErrorMessage,
        UIR.RoleId AS RoleIds, UIR2.RoleNames AS RoleNames,
        UIUG.GroupId AS GroupIds, UIUG2.GroupNames AS GroupNames,
        '' AS RefreshToken, '' as Token, NULL AS TokenID,
		USR.CreatedBy, USR.Location, USR.MugShot, NULL AS MugShotImage,
        @ISSA AS ISSA
		FROM		Users			    USR
		LEFT JOIN	#TempUserInRole	    UIR		        ON USR.UserId			= UIR.UserId
        LEFT JOIN	#TempUserInRole2	UIR2		    ON USR.UserId			= UIR2.UserId
        LEFT JOIN	#TempUserInGroup	UIUG		    ON USR.UserId			= UIR.UserId
        LEFT JOIN	#TempUserInGroup2	UIUG2		    ON USR.UserId			= UIR2.UserId
		WHERE 
		USR.IsDeleted = 0 AND USR.IsActive = 1 AND
		USR.UserName = @UserName;


-- spGetUserDetails 'shreyas','::1'

		
	END TRY

	BEGIN CATCH
		SET @IsError = 1;

		SELECT CAST(0x0 AS uniqueidentifier) AS UserId, NULL AS UserName, NULL AS FirstName, NULL AS Initials, NULL AS LastName, NULL AS JobTitle, 
		NULL AS UserEmail, 0 AS IsActive, NULL AS InactiveDate, 
		NULL AS InactiveReason, ERROR_MESSAGE() AS ValidateResponse, 
		ERROR_NUMBER() AS ErrorId, @IsError AS IsError, NULL AS ErrorMessage,
		NULL AS RoleIds,NULL AS RoleNames,
        NULL AS GroupIds, NULL AS GroupNames,
        '' AS RefreshToken,'' as Token, NULL AS TokenID,
		CAST(0x0 AS UNIQUEIDENTIFIER) AS CreatedBy, NULL AS Location, NULL AS MugShot, NULL AS MugShotImage,
        0 AS ISSA;
		
	END CATCH
END
GO
/****** Object:  StoredProcedure [dbo].[spGetUserNameByUserGuid]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spGetUserNameByUserGuid] 
(
	@UserGuid		UNIQUEIDENTIFIER
)
AS
BEGIN
	SELECT
        [UserId]
		[UserName]
		,[FirstName]
		,[LastName]
	FROM [dbo].[Users] Where UserId = @UserGuid
END
GO
/****** Object:  StoredProcedure [dbo].[spInsertEnquiryData]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spInsertEnquiryData] 
	(
        @Name VARCHAR(50),
        @PhoneNumber VARCHAR(50),
        @AlternatePhoneNumber VARCHAR(50),
        @Email VARCHAR(50),
        @EnquiryDescription VARCHAR(500),
        @EnquiredProduct VARCHAR(500)
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @IsError BIT = 0;
	DECLARE @InsertOutput TABLE
	(
	  InsertedEnquiryID UNIQUEIDENTIFIER
	)
	DECLARE @EnquiryID UNIQUEIDENTIFIER;

	BEGIN TRY
		INSERT INTO [dbo].[Enquiries]
           ([EnquiryID]
           ,[Name]
           ,[PhoneNumber]
           ,[AlternatePhoneNumber]
           ,[Email]
           ,[EnquiryDescription]
           ,[EnquiredProduct]
		   ,[CreatedDate])
		OUTPUT INSERTED.EnquiryID INTO @InsertOutput
		VALUES
           (NEWID()
           ,@Name
           ,@PhoneNumber
           ,@AlternatePhoneNumber
           ,@Email
           ,@EnquiryDescription
           ,@EnquiredProduct
		   ,GETDATE())

		SELECT @EnquiryID = InsertedEnquiryID FROM @InsertOutput;

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, NULL AS ValidateResponse, ObjectGuid = @EnquiryID;
	END TRY
	BEGIN CATCH
		SET @IsError = 1
		SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse, EnquiryID = NULL;
	END CATCH
	
END
GO
/****** Object:  StoredProcedure [dbo].[spLogOff]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spLogOff] 
	(	
		@UserId			UNIQUEIDENTIFIER,
		@UserName		VARCHAR(100),
		@UserIP			VARCHAR(20)
	)
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @IsError BIT	= 0;

	BEGIN TRY
    
		INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, FailedLoginDate , SuccessLogoffDate , UserAuditDescription)
		VALUES(@UserId, @UserIP, NULL, NULL, GETDATE(), 'Successful log off');

        UPDATE Token SET IsDeleted = 1, DeletedDate = GETDATE() WHERE GrantedTo = @UserName

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User logged off successfully.' AS ValidateResponse;

	END TRY
    
	BEGIN CATCH
		SET @IsError = 1
		INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, FailedLoginDate , SuccessLogoffDate , UserAuditDescription)
		VALUES(@UserId, @UserIP, NULL, NULL, NULL, Concat('Error in log off user ', @UserName));

		SELECT CONVERT(Varchar,  ERROR_NUMBER()) AS ErrorId, @IsError as IsError, ERROR_MESSAGE() AS ErrorMessage, 'Error in logging off user.' AS ValidateResponse;

    END Catch
		
END
GO
/****** Object:  StoredProcedure [dbo].[spUpdateUserLoginStatus]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateUserLoginStatus]
(  
    @UserId UNIQUEIDENTIFIER,
    @MaxUnsuccessfulLoginAttempts INT
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
    SET NOCOUNT ON;  
    DECLARE @IsError BIT = 0;
    DECLARE @UnsuccessfulCount INT = 0;
	DECLARE @ErrorMessage VARCHAR(50) = '';

    BEGIN TRY  

		-- Retrieve the current UnsuccessfulCount
		SELECT @UnsuccessfulCount = UnsuccessfullCount
		FROM Users
		WHERE UserId = @UserId

		IF @UnsuccessfulCount > @MaxUnsuccessfulLoginAttempts
		BEGIN
			-- User exceeded maximum login attempts
			UPDATE Users
			SET IsUserLocked = 1, UnsuccessfullCount = @UnsuccessfulCount + 1
			WHERE UserId = @UserId

			SET @ErrorMessage = 'You have exceeded maximum login attempts!';

		END
		ELSE
		BEGIN
			-- User still has login attempts left
			UPDATE Users
			SET UnsuccessfullCount = @UnsuccessfulCount + 1
			WHERE UserId = @UserId

			SET @ErrorMessage = CONCAT('You have ',  @MaxUnsuccessfulLoginAttempts - @UnsuccessfulCount , ' login attempt(s) left!');
		END

		SELECT 0 AS ErrorId, @IsError AS IsError, 
        'No error' AS ErrorMessage,@ErrorMessage AS ValidateResponse
    
    END TRY  
        
    BEGIN CATCH  

        SET @IsError = 1;   
        SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, 
        ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
        
    END CATCH  
  
END  
GO
/****** Object:  StoredProcedure [dbo].[spUpsertAttributes]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spUpsertAttributes]
    @AttributeId uniqueidentifier,
    @AttributeName varchar(100),
    @AttributePath varchar(100),
    @IsComponent bit,
    @CreatedById uniqueidentifier
AS
BEGIN

-- spUpsertAttributes NULL,'test-attr','/test-attr',1,'0fa9b4e3-9556-4e3a-aaa9-5885b3fdab13',1,0
--select * from attributes
	DECLARE @IsError BIT = 0  
	BEGIN TRY  

		IF EXISTS(SELECT 1 FROM Attributes WHERE IsActive = 1 AND AttributePath = @AttributePath)
			BEGIN   
				SET @IsError = 1;
				SELECT 1 AS ErrorId, @IsError AS IsError, 'Duplication of attribute not allowed' AS ErrorMessage, 'Duplication of attribute not allowed' AS ValidateResponse
			END
		ELSE
			BEGIN

				MERGE INTO Attributes AS target
				USING (VALUES (@AttributeId, @AttributeName, @AttributePath, @IsComponent, @CreatedById)) AS source (AttributeId, AttributeName, AttributePath, IsComponent, CreatedById)
				ON target.AttributeId = source.AttributeId
				WHEN MATCHED THEN
					UPDATE SET
						target.AttributeName = source.AttributeName,
						target.AttributePath = source.AttributePath,
						target.IsComponent = source.IsComponent,
						target.ModifiedById = source.CreatedById,
						target.ModifiedDate = GETDATE()
				WHEN NOT MATCHED THEN
					INSERT (AttributeName, AttributePath, IsComponent, CreatedById, CreatedDate)
					VALUES (source.AttributeName, source.AttributePath, source.IsComponent, source.CreatedById, GETDATE());

				SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'Attribute details updated sucessfully' AS ValidateResponse;

			END

		


	END TRY
	BEGIN CATCH
		
		SET @IsError = 1; 
        SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse;

	END CATCH
		
END
GO
/****** Object:  StoredProcedure [dbo].[spUpsertRole]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpsertRole]
    @RoleId uniqueidentifier,
    @RoleName varchar(50),
    @RoleDescription varchar(500),
    @CreatedById uniqueidentifier,
	@CopiedRoleId uniqueidentifier = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @IsError BIT = 0;
	DECLARE @OutputTbl TABLE (ID UNIQUEIDENTIFIER);
	DECLARE @InsertedRoleId UNIQUEIDENTIFIER;
	CREATE TABLE #tempUserAttributesByRole (UserAttributeId UNIQUEIDENTIFIER);
	DECLARE @ErrorMessage VARCHAR(100);

	BEGIN TRY  
		
		BEGIN TRANSACTION

		IF EXISTS (SELECT 1 FROM ROLE WHERE RoleName = @RoleName)
			BEGIN
		        SET @IsError = 1;
			    SELECT 1 AS ErrorId, @IsError as IsError, 'Role name duplication not allowed' AS ErrorMessage, 'Role name duplication not allowed' AS ValidateResponse
				
			END
        ELSE
			BEGIN  
				
				MERGE INTO Role AS target
				USING (VALUES (@RoleId, @RoleName, @RoleDescription, @CreatedById)) AS source (RoleId, RoleName, RoleDescription, CreatedById)
				ON target.RoleId = source.RoleId
				WHEN MATCHED THEN
					UPDATE SET
						target.RoleName = source.RoleName,
						target.RoleDescription = source.RoleDescription,
						target.ModifiedById = source.CreatedById,
						target.ModifiedDate = GETDATE()
				WHEN NOT MATCHED THEN
					INSERT (RoleName, RoleDescription, CreatedById, CreatedDate)
					VALUES (source.RoleName, source.RoleDescription, source.CreatedById, GETDATE())
					OUTPUT INSERTED.RoleId INTO @OutputTbl(ID);

				IF(@CopiedRoleId IS NOT NULL)
					BEGIN
						SELECT @InsertedRoleId = ID FROM @OutputTbl;

						INSERT INTO #tempUserAttributesByRole
						SELECT UserAttributeId FROM UserAccessMatrix WHERE RoleId = @CopiedRoleId AND IsActive = 1 AND IsDeleted = 0;

						MERGE UserAccessMatrix AS target
						USING #tempUserAttributesByRole AS source
							ON target.RoleId = @InsertedRoleId
						WHEN NOT MATCHED BY target
						THEN 
							INSERT (
							RoleId,	UserAttributeId, UserAccessDescription, CreatedById, CreatedDate
							) VALUES (@InsertedRoleId, source.UserAttributeId, NULL, @CreatedById, GETDATE());
					END

				SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'Role details updated sucessfully' AS ValidateResponse;
				END
		
		COMMIT TRANSACTION

		
            
	END TRY
	BEGIN CATCH 

		ROLLBACK TRANSACTION
		SET @IsError = 1; 
        SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse;

	END CATCH
   
END
GO
/****** Object:  StoredProcedure [dbo].[spUpsertUser]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spUpsertUser] 
(
		@UserId				    UNIQUEIDENTIFIER,
		@UserName			    VARCHAR(100),
		@Password				VARCHAR(50),
		@UserIP				    VARCHAR(50),
		@FirstName			    VARCHAR(200),
		@LastName			    VARCHAR(200),
		@JobTitle			    VARCHAR(200),
		@Location			    VARCHAR(100),
		@MugShot			    VARBINARY(MAX),
		@RoleIds			    VARCHAR(MAX),
        @DefaultAttributeIds    VARCHAR(MAX),
        @IsUserLocked		    BIT,
        @IsActive   		    BIT,
		@CreatedBy			    UNIQUEIDENTIFIER
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;
	DECLARE @CurrentUserIdTable TABLE (UserId UniqueIdentifier);
	DECLARE @ValidateMessage		VARCHAR(200)	= ''
    DECLARE @ErrorMessage           VARCHAR(200)    = ''
	DECLARE @IsError				BIT				= 0;
	DECLARE @IsLoginFailed			BIT				= 0;
	DECLARE	@IsLogOff				BIT				= 0			
	DECLARE	@IsUserAcceptance		BIT				= 0			
	DECLARE @IsValidUser			BIT				= 0;
	DECLARE @DEFAULTGUID			UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000';
	DECLARE @CurrentUserId UniqueIdentifier;
	
	BEGIN TRY

        -- Insert statements for procedure here
      BEGIN TRANSACTION; 

		-- Check if the user exists
		IF EXISTS(SELECT 1 FROM Users WHERE UserId = @UserId)
		BEGIN
			-- Check for duplicate UserName
			IF EXISTS(SELECT 1 FROM USERS WHERE UserName = @USERNAME AND IsDeleted = 0 AND UserId != @UserId)
			BEGIN
				SET @IsValidUser = 0;

				-- Log the duplicate user
				INSERT INTO UserAudit(UserId, UserIP, FailedLoginDate, UserAuditDescription)
				VALUES(@CreatedBy, @UserIP, GETDATE(), CONCAT('Duplicate user ', @UserName, ' is not allowed'));

				SET @IsError = 1;
        
				-- Return an error message
				SELECT -1 AS ErrorId, @IsError AS IsError, CONCAT('Duplicate user ', @Username, ' is not allowed!!') AS ErrorMessage, 
					   CONCAT('Duplicate user ', @Username, ' is not allowed!!') AS ValidateResponse;
			END
			ELSE
			BEGIN
				SET @IsValidUser = 1;

				-- Update user details
				UPDATE Users 
				SET UserName = @UserName,
					Password = @Password,
					FirstName = @FirstName,
					LastName = @LastName,
					JobTitle = @JobTitle,
					Location = @Location,
					Mugshot = @MugShot,
					DefaultAttributeIds = @DefaultAttributeIds,
					IsUserLocked = @IsUserLocked,
					IsActive = @IsActive,
					ModifiedBy = @CreatedBy,
					ModifiedDate = GETDATE()
				WHERE UserId = @UserId;

				-- Delete roles that are not in the provided list
				DELETE FROM UserInRole
				WHERE UserId = @UserId AND RoleId NOT IN (SELECT VALUE FROM STRING_SPLIT(@RoleIds, ','));

				-- Activate roles that are in the provided list
				UPDATE UserInRole
				SET IsActive = 1, DeletedById = NULL, DeletedDate = NULL
				WHERE UserId = @UserId AND IsActive = 0 AND RoleId IN (SELECT VALUE FROM STRING_SPLIT(@RoleIds, ','));

				-- Insert new roles
				INSERT INTO UserInRole(UserInRoleId, UserId, RoleId, IsActive, CreatedById, CreatedDate, ModifiedById, ModifiedDate)
				SELECT NEWID(), @UserId, VALUE, 1, @CreatedBy, GETDATE(), @CreatedBy, GETDATE()
				FROM STRING_SPLIT(@RoleIds, ',')
				WHERE VALUE NOT IN (SELECT RoleId FROM UserInRole WHERE UserId = @UserId);

				-- Log the successful update
				INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, UserAuditDescription)
				VALUES(@UserId, @UserIP, GETDATE(), CONCAT('Update user ', @UserName, ' successful'));

				SET @IsError = 0;

				-- Return a success message
				SELECT -1 AS ErrorId, @IsError AS IsError, 'No error' AS ErrorMessage, 'User details updated successfully...' AS ValidateResponse;
			END
		END
		ELSE
		BEGIN
			-- User does not exist, check for duplicate UserName
			IF EXISTS(SELECT 1 FROM USERS WHERE UserName = @USERNAME AND IsDeleted = 0)
			BEGIN
				SET @IsValidUser = 0;

				-- Log the duplicate user
				INSERT INTO UserAudit(UserId, UserIP, FailedLoginDate, UserAuditDescription)
				VALUES(@CreatedBy, @UserIP, GETDATE(), CONCAT('Duplicate user ', @UserName, ' is not allowed'));

				SET @IsError = 1;

				-- Return an error message
				SELECT -1 AS ErrorId, @IsError AS IsError, CONCAT('Duplicate user ', @Username, ' is not allowed!!') AS ErrorMessage, 
					   CONCAT('Duplicate user ', @Username, ' is not allowed!!') AS ValidateResponse;
			END
			ELSE
			BEGIN
				SET @IsValidUser = 1;

				-- Create a new user
				INSERT INTO Users(UserName, Password, FirstName, LastName, JobTitle, Location, DefaultAttributeIds, CreatedBy, CreatedDate)
				OUTPUT INSERTED.UserId INTO @CurrentUserIdTable(UserId)
				VALUES(@UserName, @Password, @FirstName, @LastName, @JobTitle, @Location, @DefaultAttributeIds, @CreatedBy, GETDATE());

				SELECT @CurrentUserId = UserId FROM @CurrentUserIdTable;

				-- Log the successful user creation
				INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, UserAuditDescription)
				VALUES(@CreatedBy, @UserIP, GETDATE(), CONCAT('Creating new user ', @UserName, ' successful'));

				-- Insert new roles
				INSERT INTO UserInRole(UserInRoleId, UserId, RoleId, IsActive, CreatedById, CreatedDate, ModifiedById, ModifiedDate)
				SELECT NEWID(), @CurrentUserId, VALUE, 1, @CreatedBy, GETDATE(), @CreatedBy, GETDATE()
				FROM STRING_SPLIT(@RoleIds, ',')
				WHERE VALUE NOT IN (SELECT RoleId FROM UserInRole WHERE UserId = @CurrentUserId);

				SET @IsError = 0;

				SELECT -1 AS ErrorId, @IsError AS IsError, 'No error' AS ErrorMessage, 'User details created successfully...' AS ValidateResponse;
			END
		END;

		COMMIT TRANSACTION; -- Commit the transaction

	END TRY
    
	BEGIN CATCH
	ROLLBACK TRANSACTION
		SET @IsError		= 1
		SET @IsLoginFailed	= 1
		SET @IsLogOff		= 1
		SET @IsValidUser	= 0;
		Select ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE()  AS ErrorMessage, 
		'Error in creating user 'AS ValidateResponse
    END CATCH
		
END

GO
/****** Object:  StoredProcedure [dbo].[spUpsertUserAccessMatrix]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpsertUserAccessMatrix]
(
	@UserAccessMatrixId uniqueidentifier,
    @IsActive bit,
    @UserAccessDescription varchar(400),
    @RoleId uniqueidentifier,
    @CreatedById uniqueidentifier,
	@UserAttributeData udtUserAccessMatrixFieldvalues READONLY
)
AS
BEGIN
	DECLARE @IsError BIT = 0  
	DECLARE @Count INT

	BEGIN TRY  
		BEGIN TRANSACTION

		UPDATE UserAccessMatrix SET IsActive = 0, IsDeleted = 1,DeletedById=@CreatedById,DeletedDate=GETDATE()
		WHERE RoleId = @RoleId; -- Set all existing records inactive, and then, in case of update either set them active one by one

		SELECT @Count = COUNT(*) FROM @UserAttributeData;

		IF @Count > 0
		BEGIN

			MERGE dbo.UserAccessMatrix AS target
			USING @UserAttributeData AS source
			ON (target.RoleId = @RoleId AND target.UserAttributeId = source.UserAttributeId)
			WHEN MATCHED 
			THEN
				UPDATE SET target.IsActive=1,target.ModifiedById=@CreatedById,target.ModifiedDate=GETDATE(),
						target.IsDeleted=0,target.DeletedById=NULL,target.DeletedDate=NULL
			WHEN NOT MATCHED BY target 
			THEN
				INSERT (RoleId, UserAttributeId, UserAccessDescription, CreatedById, CreatedDate) 
                    VALUES(source.RoleId, source.UserAttributeId, @UserAccessDescription, @CreatedById, GETDATE());
		END

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User Access details updated sucessfully' AS ValidateResponse;
		COMMIT TRANSACTION
		
            
	END TRY
	BEGIN CATCH 
		
		SET @IsError = 1; 
        SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse;

	END CATCH
   
END
GO
/****** Object:  StoredProcedure [dbo].[spUpsertUserAttribute]    Script Date: 17-10-2023 21:25:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   PROCEDURE [dbo].[spUpsertUserAttribute]
(
	@UserAttributeId uniqueidentifier,
    @UserAttributeName varchar(100),
    @UserAttributeDescription varchar(400),
    @AttributeId uniqueidentifier,
    @CreatedById uniqueidentifier,
	@CrudIds varchar(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IsError BIT = 0  
	BEGIN TRY  

		IF EXISTS(SELECT 1 FROM UserAttributes WHERE UserAttributeName = @UserAttributeName AND IsActive = 1 AND IsDeleted = 0)
			BEGIN
				SELECT 0 AS ErrorId, @IsError AS IsError, 'Duplicate Attribute-Access Name!' AS ErrorMessage, 'Duplicate Attribute-Access Name!' AS ValidateResponse
			END
		ELSE
			BEGIN
				MERGE INTO UserAttributes AS target
				USING (VALUES (
					@UserAttributeId,
					@UserAttributeName,
					@UserAttributeDescription,
					@AttributeId,
					@CreatedById,
					@CrudIds
					)) AS source (UserAttributeId, UserAttributeName, UserAttributeDescription, AttributeId, CreatedById, CrudIds)
					ON target.UserAttributeId = source.UserAttributeId
				WHEN MATCHED THEN
					UPDATE SET
						target.UserAttributeName = source.UserAttributeName,
						target.UserAttributeDescription = source.UserAttributeDescription,
						target.AttributeId = source.AttributeId,
						target.ModifiedById = source.CreatedById,
						target.ModifiedDate = GETDATE(),
						target.CrudIds = source.CrudIds
				WHEN NOT MATCHED THEN
					INSERT (UserAttributeName, UserAttributeDescription, AttributeId, CreatedById, CreatedDate, CrudIds)
					VALUES (
						source.UserAttributeName,
						source.UserAttributeDescription,
						source.AttributeId,
						source.CreatedById,
						GETDATE(),
						source.CrudIds
					);

				SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User Attribute details updated sucessfully' AS ValidateResponse;

			END

	END TRY
	BEGIN CATCH 
		
		SET @IsError = 1; 
        SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse;

	END CATCH
   
END
GO
USE [master]
GO
ALTER DATABASE [BaseCrocs] SET  READ_WRITE 
GO
