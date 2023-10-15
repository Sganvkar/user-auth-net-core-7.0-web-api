USE [MSS]
GO

/****** Object:  Table [dbo].[Enquiries]    Script Date: 25-04-2023 23:22:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Enquiries](
	[EnquiryID] [uniqueidentifier] NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[PhoneNumber] [varchar](50) NOT NULL,
	[AlternatePhoneNumber] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[EnquiryDescription] [varchar](500) NULL,
	[EnquiredProduct] [varchar](500) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[UpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_Enquiries] PRIMARY KEY CLUSTERED 
(
	[EnquiryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Enquiries] ADD  CONSTRAINT [DF_Enquiries_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

