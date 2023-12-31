USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spUpsertProduct]    Script Date: 25-04-2023 21:52:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpsertProduct]
(	
	@ProductID UNIQUEIDENTIFIER,
	@ProductName VARCHAR(100),
	@ProductDescription VARCHAR(500),
	@SubCategoryID UNIQUEIDENTIFIER
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		DECLARE @InsertProductOutput TABLE( InsertedProductID UNIQUEIDENTIFIER );
		DECLARE @OutputProductID UNIQUEIDENTIFIER;
		DECLARE @IsError BIT = 0;

	BEGIN TRY

		INSERT INTO Products(ProductID,ProductName,ProductDescription,SubCategoryID,CreatedDate)
		OUTPUT INSERTED.ProductID INTO @InsertProductOutput
		VALUES (NEWID(),@ProductName,@ProductDescription,@SubCategoryID,GETDATE())

		SELECT @OutputProductID = InsertedProductID FROM @InsertProductOutput;

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, NULL AS ValidateResponse, ObjectGuid = @OutputProductID;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @IsError = 1
		SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse, ObjectGuid = NULL;
	END CATCH
END
