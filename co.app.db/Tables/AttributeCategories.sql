USE [MSS]
GO

/****** Object:  Table [dbo].[AttributeCategories]    Script Date: 13-07-2023 23:24:41 ******/
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

ALTER TABLE [dbo].[AttributeCategories] ADD  CONSTRAINT [DF_Table_1_AttributeId]  DEFAULT (newid()) FOR [AttributeCategoryId]
GO

