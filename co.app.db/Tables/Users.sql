USE [MSS]
GO

/****** Object:  Table [dbo].[Users]    Script Date: 13-07-2023 23:30:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Users](
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [varchar](100) NOT NULL,
	[FirstName] [varchar](200) NOT NULL,
	[Initials] [varchar](20) NULL,
	[LastName] [varchar](200) NULL,
	[JobTitle] [varchar](200) NOT NULL,
	[Location] [varchar](200) NULL,
	[UserEmail] [varchar](200) NULL,
	[PhoneNumber] [varchar](20) NULL,
	[IsActive] [bit] NOT NULL,
	[InactiveDate] [datetime] NULL,
	[InactiveReason] [varchar](400) NULL,
	[IsUserLocked] [bit] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [uniqueidentifier] NULL,
	[ModifiedDate] [datetime] NULL,
	[DeletedBy] [uniqueidentifier] NULL,
	[DeletedDate] [datetime] NULL,
	[UserPhoto] [varchar](max) NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_UserId]  DEFAULT (newid()) FOR [UserId]
GO


