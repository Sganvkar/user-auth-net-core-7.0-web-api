USE [BaseCrocs]
GO
/****** Object:  StoredProcedure [dbo].[spUpsertAttributes]    Script Date: 17-10-2023 20:19:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[spUpsertAttributes]
    @AttributeId uniqueidentifier,
    @AttributeName varchar(100),
    @AttributePath varchar(100),
    @IsComponent bit,
    @CreatedById uniqueidentifier
AS
BEGIN

-- spUpsertAttributes NULL,'test-attr','/test-attr',1,'0fa9b4e3-9556-4e3a-aaa9-5885b3fdab13',1,0
--select * from attributes
	DECLARE @IsError BIT = 0 ;
	BEGIN TRY  

		IF EXISTS(SELECT 1 FROM Attributes WHERE IsActive = 1 AND AttributePath = @AttributePath)
			BEGIN   
				SET @IsError = 1;
				SELECT 1 AS ErrorId, @IsError AS IsError, 'Duplication of attribute not allowed' AS ErrorMessage, 'Duplication of attribute not allowed' AS ValidateResponse
			END
		ELSE
			BEGIN

				MERGE INTO Attributes AS target
				USING (VALUES (@AttributeId, @AttributeName, @AttributePath, @IsComponent, @CreatedById)) AS source (AttributeId, AttributeName, AttributePath, IsComponent, CreatedById)
				ON target.AttributeId = source.AttributeId
				WHEN MATCHED THEN
					UPDATE SET
						target.AttributeName = source.AttributeName,
						target.AttributePath = source.AttributePath,
						target.IsComponent = source.IsComponent,
						target.ModifiedById = source.CreatedById,
						target.ModifiedDate = GETDATE()
				WHEN NOT MATCHED THEN
					INSERT (AttributeName, AttributePath, IsComponent, CreatedById, CreatedDate)
					VALUES (source.AttributeName, source.AttributePath, source.IsComponent, source.CreatedById, GETDATE());

				SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'Attribute details updated sucessfully' AS ValidateResponse;

			END

		


	END TRY
	BEGIN CATCH
		
		SET @IsError = 1; 
        SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse;

	END CATCH
		
END
