USE [MSS]
GO

/****** Object:  Table [dbo].[UserAudit]    Script Date: 13-07-2023 23:29:12 ******/
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

ALTER TABLE [dbo].[UserAudit] ADD  CONSTRAINT [DF_UserAudit_UserAuditId]  DEFAULT (newid()) FOR [UserAuditId]
GO


