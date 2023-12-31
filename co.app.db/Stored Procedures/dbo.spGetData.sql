USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spGetData]    Script Date: 22-03-2023 11:53:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER PROCEDURE [dbo].[spGetData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SELECT c.categoryID, c.categoryName,
	i.ImageBlob AS categoryImage,
	SubCategories = (
						 SELECT sc.subCategoryID, sc.subCategoryName,
						 products = (
							SELECT p.productID,p.productName,
							variants = (
								SELECT v.variantID, v.variantModelNo, v.variantDetails, v.variantDescription,
								documents = (
									SELECT d.documentName, d.documentType, d.documentBlob
									FROM Documents d 
									WHERE v.VariantID = d.DocumentEntityID
									FOR JSON PATH, INCLUDE_NULL_VALUES
								)
								FROM Variants v
								WHERE p.ProductID = v.ProductID
								FOR JSON PATH, INCLUDE_NULL_VALUES
							)
							FROM Products p
							WHERE sc.SubCategoryID = p.SubCategoryID
							FOR JSON PATH, INCLUDE_NULL_VALUES
						 )
						 FROM SubCategories sc 
						 WHERE c.CategoryID = sc.CategoryID
						 FOR JSON PATH, INCLUDE_NULL_VALUES
					)
	FROM Categories c
	INNER JOIN Images i ON i.ImageEntityID = c.CategoryID
	


END
