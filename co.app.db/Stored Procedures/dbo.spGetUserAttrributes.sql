USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAttrributes]    Script Date: 11-10-2023 20:39:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[spGetUserAttrributes]  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
    SET NOCOUNT ON;
    SELECT UserAttributeId
	, UserAttributeName
	, UserAttributeDescription
	, UA.AttributeId
    , A.AttributeName
	, A.AttributePath
	, CrudIds
    , UA.CreatedById
	, UA.CreatedDate
	, UA.ModifiedById
	, UA.ModifiedDate
    , (SELECT ua.UserAttributeId AS 'userAttributeId', ua.AttributeId AS 'attributeId', cm.CrudId AS crudId, cm.CrudName AS crudName FROM Crud cm 
            WHERE cm.CrudId IN (SELECT Value FROM STRING_SPLIT( UA.CrudIds, ',')) 
			FOR JSON AUTO) AS AttributeAccessList
    FROM UserAttributes UA  
    LEFT JOIN Attributes A ON UA.AttributeId = A.AttributeId
    WHERE UA.IsActive = 1 AND UA.IsDeleted = 0;
END 
