USE [Logs]
GO
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







