USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spUpsertVariant]    Script Date: 25-04-2023 22:06:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spUpsertVariant]
(	@VariantID UNIQUEIDENTIFIER,
	@VariantModelNo VARCHAR(50),
	@VariantDetails	VARCHAR(MAX),
	@ProductID UNIQUEIDENTIFIER
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		DECLARE @InsertProductOutput TABLE( InsertedProductID UNIQUEIDENTIFIER );
		DECLARE @IsError BIT = 0;

	BEGIN TRY
		BEGIN TRANSACTION

			INSERT INTO Variants(VariantID,VariantModelNo,VariantDetails,ProductID,CreatedDate)
			VALUES (NEWID(),@VariantModelNo,@VariantDetails,@ProductID,GETDATE())

		COMMIT TRANSACTION

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, NULL AS ValidateResponse
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @IsError = 1
		SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse;
	END CATCH
END
