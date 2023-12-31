USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spUpsertUserAccessMatrix]    Script Date: 07-10-2023 10:21:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpsertUserAccessMatrix]
(
	@UserAccessMatrixId uniqueidentifier,
    @IsActive bit,
    @UserAccessDescription varchar(400),
    @RoleId uniqueidentifier,
    @CreatedById uniqueidentifier,
	@UserAttributeData udtUserAccessMatrixFieldvalues READONLY
)
AS
BEGIN
	DECLARE @IsError BIT = 0  
	DECLARE @Count INT

	BEGIN TRY  
		BEGIN TRANSACTION

		UPDATE UserAccessMatrix SET IsActive = 0, IsDeleted = 1,DeletedById=@CreatedById,DeletedDate=GETDATE()
		WHERE RoleId = @RoleId; -- Set all existing records inactive, and then, in case of update either set them active one by one

		SELECT @Count = COUNT(*) FROM @UserAttributeData;

		IF @Count > 0
		BEGIN

			MERGE dbo.UserAccessMatrix AS target
			USING @UserAttributeData AS source
			ON (target.RoleId = @RoleId AND target.UserAttributeId = source.UserAttributeId)
			WHEN MATCHED 
			THEN
				UPDATE SET target.IsActive=1,target.ModifiedById=@CreatedById,target.ModifiedDate=GETDATE(),
						target.IsDeleted=0,target.DeletedById=NULL,target.DeletedDate=NULL
			WHEN NOT MATCHED BY target 
			THEN
				INSERT (RoleId, UserAttributeId, UserAccessDescription, CreatedById, CreatedDate) 
                    VALUES(source.RoleId, source.UserAttributeId, @UserAccessDescription, @CreatedById, GETDATE());
		END

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User Access details updated sucessfully' AS ValidateResponse;
		COMMIT TRANSACTION
		
            
	END TRY
	BEGIN CATCH 
		
		SET @IsError = 1; 
        SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse;

	END CATCH
   
END
