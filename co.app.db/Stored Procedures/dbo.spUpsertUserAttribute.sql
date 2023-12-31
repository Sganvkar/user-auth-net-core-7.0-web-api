USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spUpsertUserAttribute]    Script Date: 05-10-2023 20:08:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[spUpsertUserAttribute]
(
	@UserAttributeId uniqueidentifier,
    @UserAttributeName varchar(100),
    @UserAttributeDescription varchar(400),
    @AttributeId uniqueidentifier,
    @CreatedById uniqueidentifier,
	@CrudIds varchar(100)
)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @IsError BIT = 0  
	BEGIN TRY  

		IF EXISTS(SELECT 1 FROM UserAttributes WHERE UserAttributeName = @UserAttributeName AND IsActive = 1 AND IsDeleted = 0)
			BEGIN
				SELECT 0 AS ErrorId, @IsError AS IsError, 'Duplicate Attribute-Access Name!' AS ErrorMessage, 'Duplicate Attribute-Access Name!' AS ValidateResponse
			END
		ELSE
			BEGIN
				MERGE INTO UserAttributes AS target
				USING (VALUES (
					@UserAttributeId,
					@UserAttributeName,
					@UserAttributeDescription,
					@AttributeId,
					@CreatedById,
					@CrudIds
					)) AS source (UserAttributeId, UserAttributeName, UserAttributeDescription, AttributeId, CreatedById, CrudIds)
					ON target.UserAttributeId = source.UserAttributeId
				WHEN MATCHED THEN
					UPDATE SET
						target.UserAttributeName = source.UserAttributeName,
						target.UserAttributeDescription = source.UserAttributeDescription,
						target.AttributeId = source.AttributeId,
						target.ModifiedById = source.CreatedById,
						target.ModifiedDate = GETDATE(),
						target.CrudIds = source.CrudIds
				WHEN NOT MATCHED THEN
					INSERT (UserAttributeName, UserAttributeDescription, AttributeId, CreatedById, CreatedDate, CrudIds)
					VALUES (
						source.UserAttributeName,
						source.UserAttributeDescription,
						source.AttributeId,
						source.CreatedById,
						GETDATE(),
						source.CrudIds
					);

				SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User Attribute details updated sucessfully' AS ValidateResponse;

			END

	END TRY
	BEGIN CATCH 
		
		SET @IsError = 1; 
        SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse;

	END CATCH
   
END
