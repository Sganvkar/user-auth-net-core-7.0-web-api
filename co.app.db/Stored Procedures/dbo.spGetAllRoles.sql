USE MSS
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE OR ALTER PROCEDURE [dbo].[spGetAllRoles]
(
	@AccessedById   UNIQUEIDENTIFIER
)
AS
BEGIN
	--select * from users
	--SELECT * FROM ROLE
	--spGetRole '8ABC7E7E-5316-4F79-8FA0-884D7FD804C7'
	SET NOCOUNT ON;
	DECLARE @IsError BIT = 0  
	DECLARE @IsSAdmin  BIT = 0;
	BEGIN TRY
		
		SET @IsSAdmin = [dbo].[CheckUserSAdmin](@AccessedById);

		SELECT R.[RoleId]
		,R.[RoleName]
		,R.[RoleDescription]
		,R.[IsActive]
		,R.[CreatedById]
		,R.[CreatedDate]
		,R.[ModifiedById]
		,R.[ModifiedDate]
		,R.[DeletedById]
		,R.[DeletedDate]
		,CONCAT(U.FIRSTNAME, ' ', U.LastName ) AS CreatedBy
		,CONCAT(U.FIRSTNAME, ' ', U.LastName ) AS ModifiedBy
		FROM [dbo].[Role] R 
		LEFT JOIN Users U on R.CreatedById = U.UserId
		WHERE R.IsActive = 1 AND R.IsDeleted = 0
		AND @IsSAdmin = 1 OR ( @IsSAdmin = 0 AND RoleName <> 'SAdmin')
		ORDER BY R.RoleName ASC

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'Operation Successful' AS ValidateResponse;

	END TRY
	BEGIN CATCH

		SET @IsError = 1; 
        SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse;

	END CATCH
	
END
GO
