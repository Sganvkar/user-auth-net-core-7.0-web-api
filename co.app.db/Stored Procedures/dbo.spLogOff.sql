USE [BaseCrocs]
GO
/****** Object:  StoredProcedure [dbo].[spLogOff]    Script Date: 16-10-2023 19:00:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[spLogOff] 
	(	
		@UserId			UNIQUEIDENTIFIER,
		@UserName		VARCHAR(100),
		@UserIP			VARCHAR(20)
	)
AS

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @IsError BIT	= 0;

	BEGIN TRY
    
		INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, FailedLoginDate , SuccessLogoffDate , UserAuditDescription)
		VALUES(@UserId, @UserIP, NULL, NULL, GETDATE(), 'Successful log off');

        UPDATE Token SET IsDeleted = 1, DeletedDate = GETDATE() WHERE GrantedTo = @UserName

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User logged off successfully.' AS ValidateResponse;

	END TRY
    
	BEGIN CATCH
		SET @IsError = 1
		INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, FailedLoginDate , SuccessLogoffDate , UserAuditDescription)
		VALUES(@UserId, @UserIP, NULL, NULL, NULL, Concat('Error in log off user ', @UserName));

		SELECT CONVERT(Varchar,  ERROR_NUMBER()) AS ErrorId, @IsError as IsError, ERROR_MESSAGE() AS ErrorMessage, 'Error in logging off user.' AS ValidateResponse;

    END Catch
		
END
