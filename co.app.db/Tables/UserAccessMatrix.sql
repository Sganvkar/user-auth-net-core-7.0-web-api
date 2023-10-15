USE [MSS]
GO

/****** Object:  Table [dbo].[UserAccessMatrix]    Script Date: 13-07-2023 23:28:35 ******/
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
 CONSTRAINT [PK_UserAccessMatrix] PRIMARY KEY CLUSTERED 
(
	[UserAccessMatrixId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserAccessMatrix] ADD  DEFAULT (newid()) FOR [UserAccessMatrixId]
GO

ALTER TABLE [dbo].[UserAccessMatrix]  WITH CHECK ADD  CONSTRAINT [FK_UserAccessMatrix_Attributes] FOREIGN KEY([UserAttributeId])
REFERENCES [dbo].[Attributes] ([AttributeId])
GO

ALTER TABLE [dbo].[UserAccessMatrix] CHECK CONSTRAINT [FK_UserAccessMatrix_Attributes]
GO

ALTER TABLE [dbo].[UserAccessMatrix]  WITH CHECK ADD  CONSTRAINT [FK_UserAccessMatrix_Role] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Role] ([RoleId])
GO

ALTER TABLE [dbo].[UserAccessMatrix] CHECK CONSTRAINT [FK_UserAccessMatrix_Role]
GO


