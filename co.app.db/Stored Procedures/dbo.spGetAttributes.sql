USE MSS
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER PROCEDURE [dbo].[spGetAttributes]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	SELECT  AttributeId
      ,AttributeName
	  ,AttributePath
      ,A.IsComponent
      ,A.CreatedById
      ,A.CreatedDate
      ,A.ModifiedById
      ,A.ModifiedDate
      ,A.IsActive
	  ,CONCAT(U.FIRSTNAME, ' ', U.LastName ) AS CreatedBy
	  ,CONCAT(US.FIRSTNAME, ' ', US.LastName ) AS ModifiedBy
	  FROM Attributes A LEFT JOIN Users U on
	  A.CreatedById=U.UserId
	  LEFT JOIN Users US on A.CreatedById=US.UserId
	  WHERE A.IsActive = 1 AND A.IsDeleted = 0

	  --SELECT * FROM ATTRIBUTES
END

GO
