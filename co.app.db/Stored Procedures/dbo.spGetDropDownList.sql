SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE OR ALTER PROCEDURE spGetDropDownList
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT c.CategoryID as categoryID, c.CategoryName as categoryName , subCategories FROM Categories c
	OUTER APPLY(
		SELECT sc.SubCategoryName AS subCategoryName ,sc.SubCategoryID AS subCategoryID
		FROM SubCategories sc
		WHERE sc.CategoryID = c.CategoryID
		FOR JSON PATH
	) sp(subCategories)
	
END
GO
