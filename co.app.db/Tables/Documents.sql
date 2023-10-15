USE [MSS]
GO

/****** Object:  Table [dbo].[Documents]    Script Date: 13-07-2023 23:26:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Documents](
	[DocumentID] [uniqueidentifier] NOT NULL,
	[DocumentEntityID] [uniqueidentifier] NOT NULL,
	[DocumentName] [varchar](100) NOT NULL,
	[DocumentType] [varchar](50) NOT NULL,
	[DocumentBlob] [varbinary](max) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Documents] PRIMARY KEY CLUSTERED 
(
	[DocumentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


