SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE spInsertData
(
	@jsonData NVARCHAR(MAX)	
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @IsError BIT = 0;
	
	BEGIN TRY
		BEGIN TRANSACTION

		--exec spInsertData @jsonData=N'{"categoryName":"Solar street lighting systems","imageType":"jpg","imageBlob":"test","subCategory":[{"subCategoryName":"CFL","products":[{"productName":"LED SSL DC","productDescription":"description","variants":[{"variantModelNo":"SL30WS-M1","variantDetails":"details"},{"variantModelNo":"SL40WS-M1","variantDetails":"details"}]}]},{"subCategoryName":"LED","products":[{"productName":"LED SSL DC","productDescription":"description","variants":[{"variantModelNo":"SL30WS-M1","variantDetails":"details"},{"variantModelNo":"SL40WS-M1","variantDetails":"details"}]},{"productName":"LED SSL DC-1","productDescription":"description","variants":[{"variantModelNo":"SL30WS-M1","variantDetails":"details"},{"variantModelNo":"SL40WS-M1","variantDetails":"details"}]}]}]}'
		--Select * from categories
		--SELECT * FROM IMAGES
		--select * from subcategories

		DECLARE @CategoryTable table(CategoryID UNIQUEIDENTIFIER )
	DECLARE @OutputCategoryID UNIQUEIDENTIFIER;

		--, @SubCategoryId UNIQUEIDENTIFIER, @ProductId UNIQUEIDENTIFIER

		-- Insert data into the parent table

		   MERGE Categories AS target
    USING (
        SELECT categoryName
        FROM OPENJSON(@jsonData)
        WITH (
            categoryName VARCHAR(100),
            subCategory NVARCHAR(MAX) AS JSON
        )
    ) AS source
    ON (1=0) -- This ensures that a new record is always inserted
    WHEN NOT MATCHED THEN
        INSERT (categoryName)
        VALUES (source.categoryName)
    OUTPUT INSERTED.CategoryID INTO @CategoryTable;

		SELECT @OutputCategoryID = CategoryID FROM @CategoryTable;

		 MERGE SubCategories AS target
			USING (
        SELECT @OutputCategoryID AS CategoryId, Field3, Field4
        FROM OPENJSON(@jsonData)
        WITH (
            subCategory NVARCHAR(MAX) AS JSON
        )
        CROSS APPLY OPENJSON(subCategory)
        WITH (
            subCategoryName NVARCHAR(50),
            products NVARCHAR(MAX) AS JSON
        )
    ) AS source
    ON (target.ParentTableId = source.ParentTableId AND target.Field3 = source.Field3) -- This ensures that only one record is inserted for each unique combination of ParentTableId and Field3
    WHEN NOT MATCHED THEN
        INSERT (ParentTableId, Field3, Field4)
        VALUES (source.ParentTableId, source.Field3, source.Field4)
    OUTPUT INSERTED.Id INTO @childTableId;


		COMMIT TRANSACTION

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, NULL AS ValidateResponse;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @IsError = 1
		SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse;
	END CATCH

END
GO