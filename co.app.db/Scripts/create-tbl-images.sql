USE [MSS]
GO

/****** Object:  Table [dbo].[Images]    Script Date: 25-04-2023 23:23:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Images](
	[ImageID] [uniqueidentifier] NOT NULL,
	[ImageEntityID] [uniqueidentifier] NOT NULL,
	[ImageType] [varchar](50) NULL,
	[ImageBlob] [varbinary](max) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Images] PRIMARY KEY CLUSTERED 
(
	[ImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Images] ADD  CONSTRAINT [DF_Images_ImageType]  DEFAULT (NULL) FOR [ImageType]
GO

ALTER TABLE [dbo].[Images] ADD  CONSTRAINT [DF_Images_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO

