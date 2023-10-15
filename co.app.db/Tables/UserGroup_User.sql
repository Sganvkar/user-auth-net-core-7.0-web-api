USE [MSS]
GO

/****** Object:  Table [dbo].[UserGroup_User]    Script Date: 13-07-2023 23:29:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UserGroup_User](
	[UserGroup_UserID] [uniqueidentifier] NOT NULL,
	[UserGroupID] [uniqueidentifier] NOT NULL,
	[UserID] [uniqueidentifier] NOT NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedBy] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
 CONSTRAINT [PK_UserGroupID_UserID] PRIMARY KEY CLUSTERED 
(
	[UserGroupID] ASC,
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
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


