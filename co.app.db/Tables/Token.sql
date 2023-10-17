USE [BaseCrocs]
GO

/****** Object:  Table [dbo].[Token]    Script Date: 16-10-2023 12:30:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Token](
	[Id] [uniqueidentifier] NOT NULL,
	[GrantedTo] [varchar](100) NOT NULL,
	[CurrentToken] [varchar](max) NOT NULL,
	[RotativeToken] [varchar](max) NOT NULL,
	[MssSecretID] [varchar](100) NULL,
	[TokenValidFrom] [datetime] NOT NULL,
	[TokenValidTo] [datetime] NOT NULL,
	[ClientId] [varchar](100) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[DeletedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Token] ADD  CONSTRAINT [DF_Token_Id]  DEFAULT (newid()) FOR [Id]
GO


