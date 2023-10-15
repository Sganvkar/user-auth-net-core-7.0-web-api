USE MSS
GO
CREATE OR ALTER PROCEDURE [dbo].[spCheckUser]
(
	@Username VARCHAR(100),
	@UserIP VARCHAR(10)
)
AS
BEGIN

--spCheckUser "test_user","12345"

DECLARE @IsActive BIT = 0;
DECLARE @CurrentUserId UNIQUEIDENTIFIER;
DECLARE @IsUserLocked BIT = 0;
DECLARE @IsValidUser BIT = 0;
DECLARE @ErrorMessage VARCHAR(250);
DECLARE @IsError BIT = 0;
DECLARE @ErrorId INT = 0; 

BEGIN TRY

	IF EXISTS(SELECT * FROM Users WHERE UserName = @Username AND IsDeleted != 1)
		BEGIN
		
			SET @IsValidUser = 1
			SET @ErrorMessage = 'Valid user';

			 SELECT @IsActive = ISNULL(IsActive,0), @IsUserLocked = ISNULL(IsUserLocked, 0), @CurrentUserId = UserId 
			 FROM Users WHERE UserName = @UserName;

			 IF(@IsUserLocked=1)
				 BEGIN
					SET @IsValidUser = 0;
					SET @ErrorMessage = 'User has been locked, please contact administrator.';
				 END
			 ELSE IF(@IsActive=0)
				BEGIN
					SET @IsValidUser = 0;
					SET @ErrorMessage = 'User is inactive, please contact administrator.'
				END
			 
			INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, FailedLoginDate , SuccessLogoffDate , UserAuditDescription)
			VALUES(@CurrentUserId, @UserIP, NULL, GETDATE(), NULL, Concat('User ', @UserName, ' exists.'));

			SELECT UserId, UserName,
			 CASE
				WHEN @IsValidUser = 1 THEN Password
				ELSE NULL
			 END AS Password,
			IsActive, @IsValidUser As IsValidUser,0 AS ErrorId, @IsError AS IsError, '' AS ErrorMessage,  @ErrorMessage AS ValidateResponse,
			@IsUserLocked AS IsUserLocked
			FROM Users
			WHERE UserName = @UserName AND (IsDeleted IS NULL OR IsDeleted = 0);
				
		END
	ELSE
		BEGIN
			SET @IsValidUser = 0

			INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, FailedLoginDate , SuccessLogoffDate , UserAuditDescription)
			VALUES(CAST(0x0 AS UNIQUEIDENTIFIER), @UserIP, NULL, GETDATE(), NULL, 'User does not exist.');
			
			SELECT CAST(0x0 AS UNIQUEIDENTIFIER) AS UserId, @UserName AS UserName, NULL AS Password, @IsActive AS IsActive, @IsValidUser As IsValidUser,
			 0 AS ErrorId, @IsError AS IsError, NULL AS ErrorMessage,'User does not exists<br/>Please contact Administrator to create an account' AS ValidateResponse,
			@IsUserLocked AS IsUserLocked
		END

--spCheckUser "test_user","12345"
END TRY

BEGIN CATCH
	SET @IsValidUser	=	0
	SET @IsError		=	1

	SELECT CAST(0x0 AS UNIQUEIDENTIFIER) AS UserId, NULL AS UserName, NULL AS Password, 0 AS IsActive, @IsValidUser As IsValidUser,
	ERROR_NUMBER() AS ErrorId,  @IsError AS IsError,  ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse,
	@IsUserLocked AS IsUserLocked 

END CATCH
END