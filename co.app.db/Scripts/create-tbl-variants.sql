USE [MSS]
GO

/****** Object:  Table [dbo].[Variants]    Script Date: 25-04-2023 23:21:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Variants](
	[VariantID] [uniqueidentifier] NOT NULL,
	[VariantModelNo] [varchar](50) NOT NULL,
	[VariantDetails] [varchar](500) NOT NULL,
	[ProductID] [uniqueidentifier] NOT NULL,
	[VariantDescription] [varchar](max) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Variants] PRIMARY KEY CLUSTERED 
(
	[VariantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Variants] ADD  CONSTRAINT [DF_Variants_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

ALTER TABLE [dbo].[Variants]  WITH CHECK ADD  CONSTRAINT [FK_Variants_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO

ALTER TABLE [dbo].[Variants] CHECK CONSTRAINT [FK_Variants_Products]
GO

