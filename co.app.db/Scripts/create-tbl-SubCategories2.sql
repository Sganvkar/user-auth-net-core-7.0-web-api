USE [MSS]
GO

/****** Object:  Table [dbo].[SubCategories]    Script Date: 25-04-2023 23:18:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SubCategories](
	[SubCategoryID] [uniqueidentifier] NOT NULL,
	[SubCategoryName] [varchar](100) NOT NULL,
	[CategoryID] [uniqueidentifier] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_SubCategories] PRIMARY KEY NONCLUSTERED 
(
	[SubCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SubCategories] ADD  CONSTRAINT [DF_SubCategories_SubCategoryID]  DEFAULT (newid()) FOR [SubCategoryID]
GO

ALTER TABLE [dbo].[SubCategories] ADD  CONSTRAINT [DF_SubCategories_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[SubCategories]  WITH CHECK ADD  CONSTRAINT [FK_SubCategories_Categories] FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Categories] ([CategoryID])
GO

ALTER TABLE [dbo].[SubCategories] CHECK CONSTRAINT [FK_SubCategories_Categories]
GO

