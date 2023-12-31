USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spUpsertRole]    Script Date: 05-10-2023 20:56:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpsertRole]
    @RoleId uniqueidentifier,
    @RoleName varchar(50),
    @RoleDescription varchar(500),
    @CreatedById uniqueidentifier,
	@CopiedRoleId uniqueidentifier = NULL
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @IsError BIT = 0;
	DECLARE @OutputTbl TABLE (ID UNIQUEIDENTIFIER);
	DECLARE @InsertedRoleId UNIQUEIDENTIFIER;
	CREATE TABLE #tempUserAttributesByRole (UserAttributeId UNIQUEIDENTIFIER);
	DECLARE @ErrorMessage VARCHAR(100);

	BEGIN TRY  
		
		BEGIN TRANSACTION

		IF EXISTS (SELECT 1 FROM ROLE WHERE RoleName = @RoleName)
			BEGIN
		        SET @IsError = 1;
			    SELECT 1 AS ErrorId, @IsError as IsError, 'Role name duplication not allowed' AS ErrorMessage, 'Role name duplication not allowed' AS ValidateResponse
				
			END
        ELSE
			BEGIN  
				
				MERGE INTO Role AS target
				USING (VALUES (@RoleId, @RoleName, @RoleDescription, @CreatedById)) AS source (RoleId, RoleName, RoleDescription, CreatedById)
				ON target.RoleId = source.RoleId
				WHEN MATCHED THEN
					UPDATE SET
						target.RoleName = source.RoleName,
						target.RoleDescription = source.RoleDescription,
						target.ModifiedById = source.CreatedById,
						target.ModifiedDate = GETDATE()
				WHEN NOT MATCHED THEN
					INSERT (RoleName, RoleDescription, CreatedById, CreatedDate)
					VALUES (source.RoleName, source.RoleDescription, source.CreatedById, GETDATE())
					OUTPUT INSERTED.RoleId INTO @OutputTbl(ID);

				IF(@CopiedRoleId IS NOT NULL)
					BEGIN
						SELECT @InsertedRoleId = ID FROM @OutputTbl;

						INSERT INTO #tempUserAttributesByRole
						SELECT UserAttributeId FROM UserAccessMatrix WHERE RoleId = @CopiedRoleId AND IsActive = 1 AND IsDeleted = 0;

						MERGE UserAccessMatrix AS target
						USING #tempUserAttributesByRole AS source
							ON target.RoleId = @InsertedRoleId
						WHEN NOT MATCHED BY target
						THEN 
							INSERT (
							RoleId,	UserAttributeId, UserAccessDescription, CreatedById, CreatedDate
							) VALUES (@InsertedRoleId, source.UserAttributeId, NULL, @CreatedById, GETDATE());
					END

				SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'Role details updated sucessfully' AS ValidateResponse;
				END
		
		COMMIT TRANSACTION

		
            
	END TRY
	BEGIN CATCH 

		ROLLBACK TRANSACTION
		SET @IsError = 1; 
        SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse;

	END CATCH
   
END
