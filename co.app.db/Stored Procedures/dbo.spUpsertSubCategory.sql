USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spUpsertSubCategory]    Script Date: 24-04-2023 23:24:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpsertSubCategory] 
(	
	@SubCategoryID UNIQUEIDENTIFIER,
	@SubCategoryName VARCHAR(50),
	@CategoryID UNIQUEIDENTIFIER
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		DECLARE @InsertSubCategoryOutput TABLE( InsertedSubCategoryID UNIQUEIDENTIFIER );
		DECLARE @OutputSubCategoryID UNIQUEIDENTIFIER;
		DECLARE @IsError BIT = 0;

	BEGIN TRY
		INSERT INTO SubCategories(SubCategoryID,SubCategoryName,CategoryID,CreatedDate)
		OUTPUT INSERTED.SubCategoryID INTO @InsertSubCategoryOutput
		VALUES (NEWID(),@SubCategoryName,@CategoryID,GETDATE())

		SELECT @OutputSubCategoryID = InsertedSubCategoryID FROM @InsertSubCategoryOutput;

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, NULL AS ValidateResponse, ObjectGuid = @OutputSubCategoryID;
	END TRY
	BEGIN CATCH
		SET @IsError = 1
		SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse, ObjectGuid = NULL;
	END CATCH
END
