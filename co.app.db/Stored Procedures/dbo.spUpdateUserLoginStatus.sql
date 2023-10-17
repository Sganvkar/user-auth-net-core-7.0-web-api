USE [BaseCrocs]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpdateUserLoginStatus]
(  
    @UserId UNIQUEIDENTIFIER,
    @MaxUnsuccessfulLoginAttempts INT
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
    SET NOCOUNT ON;  
    DECLARE @IsError BIT = 0;
    DECLARE @UnsuccessfulCount INT = 0;
	DECLARE @ErrorMessage VARCHAR(50) = '';

    BEGIN TRY  

		-- Retrieve the current UnsuccessfulCount
		SELECT @UnsuccessfulCount = UnsuccessfullCount
		FROM Users
		WHERE UserId = @UserId

		IF @UnsuccessfulCount > @MaxUnsuccessfulLoginAttempts
		BEGIN
			-- User exceeded maximum login attempts
			UPDATE Users
			SET IsUserLocked = 1, UnsuccessfullCount = @UnsuccessfulCount + 1
			WHERE UserId = @UserId

			SET @ErrorMessage = 'You have exceeded maximum login attempts!';

		END
		ELSE
		BEGIN
			-- User still has login attempts left
			UPDATE Users
			SET UnsuccessfullCount = @UnsuccessfulCount + 1
			WHERE UserId = @UserId

			SET @ErrorMessage = CONCAT('You have ',  @MaxUnsuccessfulLoginAttempts - @UnsuccessfulCount , ' login attempt(s) left!');
		END

		SELECT 0 AS ErrorId, @IsError AS IsError, 
        'No error' AS ErrorMessage,@ErrorMessage AS ValidateResponse
    
    END TRY  
        
    BEGIN CATCH  

        SET @IsError = 1;   
        SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, 
        ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
        
    END CATCH  
  
END  
