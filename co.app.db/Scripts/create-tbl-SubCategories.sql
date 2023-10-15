CREATE TABLE dbo.SubCategories
	(
		SubCategoryID UNIQUEIDENTIFIER NOT NULL,
		SubCategoryName VARCHAR(100) NOT NULL,
		CategoryID UNIQUEIDENTIFIER NOT NULL,
		CreatedDate DATETIME NOT NULL,
		UpdatedDate DATETIME NOT NULL
		, CONSTRAINT PK_SubCategories PRIMARY KEY NONCLUSTERED (SubCategoryID)
		, CONSTRAINT FK_SubCategories_Categories FOREIGN KEY (CategoryID)
        REFERENCES Categories (CategoryID)
	)