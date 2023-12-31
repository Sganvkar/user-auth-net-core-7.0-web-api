USE [master]
GO
/****** Object:  Database [BaseLogs]    Script Date: 17-10-2023 21:26:48 ******/
CREATE DATABASE [BaseLogs]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BaseLogs', FILENAME = N'E:\MSSQL16.MSSQLSERVER\MSSQL\DATA\BaseLogs.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BaseLogs_log', FILENAME = N'E:\MSSQL16.MSSQLSERVER\MSSQL\DATA\BaseLogs_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [BaseLogs] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BaseLogs].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BaseLogs] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BaseLogs] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BaseLogs] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BaseLogs] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BaseLogs] SET ARITHABORT OFF 
GO
ALTER DATABASE [BaseLogs] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BaseLogs] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BaseLogs] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BaseLogs] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BaseLogs] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BaseLogs] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BaseLogs] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BaseLogs] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BaseLogs] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BaseLogs] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BaseLogs] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BaseLogs] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BaseLogs] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BaseLogs] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BaseLogs] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BaseLogs] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BaseLogs] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BaseLogs] SET RECOVERY FULL 
GO
ALTER DATABASE [BaseLogs] SET  MULTI_USER 
GO
ALTER DATABASE [BaseLogs] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BaseLogs] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BaseLogs] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BaseLogs] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BaseLogs] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BaseLogs] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BaseLogs', N'ON'
GO
ALTER DATABASE [BaseLogs] SET QUERY_STORE = ON
GO
ALTER DATABASE [BaseLogs] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [BaseLogs]
GO
/****** Object:  Table [dbo].[AuditLog]    Script Date: 17-10-2023 21:26:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuditLog](
	[AuditLogId] [int] IDENTITY(1,1) NOT NULL,
	[AuditLogObjectName] [nvarchar](100) NULL,
	[ClientComputerName] [nvarchar](100) NULL,
	[ObjectGUID] [uniqueidentifier] NULL,
	[ShortDescription] [nvarchar](200) NULL,
	[Details] [nvarchar](max) NULL,
	[ObjectID] [bigint] NULL,
	[UserName] [nvarchar](100) NULL,
	[UserGUID] [uniqueidentifier] NULL,
	[ClientIP] [nvarchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[AuditLogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ExceptionLog]    Script Date: 17-10-2023 21:26:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExceptionLog](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ClassName] [varchar](100) NULL,
	[MethodName] [varchar](100) NULL,
	[Message] [varchar](max) NULL,
	[Code] [varchar](max) NULL,
	[UserGUID] [varchar](50) NULL,
	[UserName] [varchar](50) NULL,
	[ClientIP] [varchar](50) NULL,
	[ClientComputerName] [varchar](50) NULL,
	[LogTimestamp] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[ExceptionLog] ADD  DEFAULT (getdate()) FOR [LogTimestamp]
GO
/****** Object:  StoredProcedure [dbo].[spUpdateExceptionLog]    Script Date: 17-10-2023 21:26:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateExceptionLog]
    @ClassName NVARCHAR(MAX),
    @MethodName NVARCHAR(MAX),
    @Message NVARCHAR(MAX),
    @Code NVARCHAR(MAX),
    @UserGUID NVARCHAR(MAX),
    @UserName NVARCHAR(MAX),
    @ClientIP NVARCHAR(MAX),
    @ClientComputerName NVARCHAR(MAX)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @IsError				BIT				= 0;

	BEGIN TRY

		INSERT INTO ExceptionLog (ClassName, MethodName, Message, Code, UserGUID, UserName, ClientIP, ClientComputerName)
		VALUES (@ClassName, @MethodName, @Message, @Code, @UserGUID, @UserName, @ClientIP, @ClientComputerName);

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, NULL AS ValidateResponse   
	END TRY
    
	BEGIN CATCH
			SET @IsError		= 1
			SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
    END Catch
		
END

GO
/****** Object:  StoredProcedure [dbo].[spUpdateUserAuditLog]    Script Date: 17-10-2023 21:26:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUpdateUserAuditLog] 
(
	@AuditLogObjectName NVARCHAR(MAX),
    @ClientComputerName NVARCHAR(MAX),
    @ObjectGUID UNIQUEIDENTIFIER,
    @ShortDescription NVARCHAR(MAX),
    @Details NVARCHAR(MAX),
    @ObjectID BIGINT,
    @UserName NVARCHAR(MAX),
    @UserGUID UNIQUEIDENTIFIER,
    @ClientIP NVARCHAR(MAX)
)
AS


BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @IsError				BIT				= 0;

	BEGIN TRY

		 INSERT INTO AuditLog (AuditLogObjectName, ClientComputerName, ObjectGUID, ShortDescription, Details, ObjectID, UserName, UserGUID, ClientIP)
		 VALUES (@AuditLogObjectName, @ClientComputerName, @ObjectGUID, @ShortDescription, @Details, @ObjectID, @UserName, @UserGUID, @ClientIP);

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, NULL AS ValidateResponse   
	END TRY
    
	BEGIN CATCH
			SET @IsError		= 1
			SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
    END Catch
		
END

GO
USE [master]
GO
ALTER DATABASE [BaseLogs] SET  READ_WRITE 
GO
