
USE [MSS]
GO

/****** Object:  Table [dbo].[Attributes]    Script Date: 13-07-2023 23:24:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Attributes](
	[AttributeId] [uniqueidentifier] NOT NULL,
	[AttributeCategoryId] [uniqueidentifier] NOT NULL,
	[AttributeName] [varchar](100) NULL,
	[AttributePath] [varchar](100) NOT NULL,
	[IsComponent] [bit] NOT NULL,
	[CreatedById] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedById] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedById] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
 CONSTRAINT [PK_Attributes] PRIMARY KEY CLUSTERED 
(
	[AttributeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Attributes] ADD  CONSTRAINT [DF_Attributes_AttributeId]  DEFAULT (newid()) FOR [AttributeId]
GO

ALTER TABLE [dbo].[Attributes]  WITH CHECK ADD  CONSTRAINT [FK_Attributes_Attributes] FOREIGN KEY([AttributeCategoryId])
REFERENCES [dbo].[AttributeCategories] ([AttributeCategoryId])
GO

ALTER TABLE [dbo].[Attributes] CHECK CONSTRAINT [FK_Attributes_Attributes]
GO

