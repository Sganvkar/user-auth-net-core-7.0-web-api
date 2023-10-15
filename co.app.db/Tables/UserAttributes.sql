USE [MSS]
GO

/****** Object:  Table [dbo].[UserAttributes]    Script Date: 13-07-2023 23:28:56 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[UserAttributes](
	[UserAttributeId] [uniqueidentifier] NOT NULL,
	[UserAttributeName] [varchar](100) NOT NULL,
	[UserAttributeDescription] [varchar](400) NOT NULL,
	[UserAttributeStatus] [bit] NOT NULL,
	[AttributeId] [uniqueidentifier] NOT NULL,
	[CreatedById] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedById] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedById] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
	[CrudId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_UserAttribute] PRIMARY KEY CLUSTERED 
(
	[UserAttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserAttributes]  WITH CHECK ADD  CONSTRAINT [FK_UserAttributes_Attributes] FOREIGN KEY([AttributeId])
REFERENCES [dbo].[Attributes] ([AttributeId])
GO

ALTER TABLE [dbo].[UserAttributes] CHECK CONSTRAINT [FK_UserAttributes_Attributes]
GO

ALTER TABLE [dbo].[UserAttributes]  WITH CHECK ADD  CONSTRAINT [FK_UserAttributes_Crud] FOREIGN KEY([CrudId])
REFERENCES [dbo].[Crud] ([CrudId])
GO

ALTER TABLE [dbo].[UserAttributes] CHECK CONSTRAINT [FK_UserAttributes_Crud]
GO


