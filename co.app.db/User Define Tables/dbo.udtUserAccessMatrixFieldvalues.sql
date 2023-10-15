-- ================================
-- Create User-defined Table Type
-- ================================
USE MSS
GO

-- Create the data type
CREATE TYPE dbo.udtUserAccessMatrixFieldvalues AS TABLE 
(
	RoleId UNIQUEIDENTIFIER NOT NULL,
	UserAttributeId UNIQUEIDENTIFIER NOT NULL
)
GO
