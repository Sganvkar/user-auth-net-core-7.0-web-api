USE [MSS]
GO

/****** Object:  Table [dbo].[UserInRole]    Script Date: 13-07-2023 23:30:28 ******/
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
	[DeletedById] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserInRole] ADD  CONSTRAINT [DF_UserInRole_UserInRoleId]  DEFAULT (newid()) FOR [UserInRoleId]
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


