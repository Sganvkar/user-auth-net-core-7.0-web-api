USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spUpsertCategory]    Script Date: 24-04-2023 22:57:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpsertCategory] 
(	
	@CategoryID UNIQUEIDENTIFIER,
	@CategoryName VARCHAR(100),
	@ImageType VARCHAR(50),
	@ImageBlob VARBINARY(MAX)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		DECLARE @InsertCategoryOutput TABLE( InsertedCategoryID UNIQUEIDENTIFIER );
		DECLARE @OutputCategoryID UNIQUEIDENTIFIER;
		DECLARE @IsError BIT = 0;

	BEGIN TRY
			INSERT INTO Categories (CategoryID,CategoryName,CreatedDate)
			OUTPUT INSERTED.CategoryID INTO @InsertCategoryOutput
			VALUES (NEWID(),@CategoryName, GETDATE())

			SELECT @OutputCategoryID = InsertedCategoryID FROM @InsertCategoryOutput;

			INSERT INTO Images (ImageID,ImageEntityID,ImageType,ImageBlob,CreatedDate)
			VALUES (NEWID(),@OutputCategoryID,@ImageType,@ImageBlob,GETDATE())

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, NULL AS ValidateResponse, ObjectGuid = @OutputCategoryID;
	END TRY
	BEGIN CATCH
		SET @IsError = 1
		SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse, ObjectGuid = NULL;
	END CATCH
END
