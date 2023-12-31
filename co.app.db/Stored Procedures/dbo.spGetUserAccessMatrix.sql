USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserAccessMatrix]    Script Date: 05-10-2023 22:08:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[spGetUserAccessMatrix]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT   statements.
	SET NOCOUNT ON;

	Declare  @temp table(
        [userAccessMatrixId] [uniqueidentifier]  NULL,
        [roleId] [uniqueidentifier] NULL,
        [roleName] [varchar](50) NULL,
        [isActive] [bit] NULL,   
        [userAttributeId] [uniqueidentifier]  NULL, 
        [userAttributeName] [varchar](50) NULL,
        [attributePath] [varchar](50) NULL,
        [crudIds] [varchar](200) NULL,
        [attributeAccessList] [varchar](MAX) NULL,
        [createdById] [uniqueidentifier] NULL,  
        [createdDate] [datetime] NULL ,  
        [modifiedById] [uniqueidentifier] NULL,  
        [modifiedDate] [datetime] NULL,  
        [createdBy] varchar(500) NULL,  
        [modifiedBy] varchar(500) NULL,   
		ID int 
    )   
	 
	INSERT INTO @temp SELECT 
        umx.UserAccessMatrixId
        ,umx.RoleId
        ,r.RoleName
        ,r.IsActive
        ,ua.UserAttributeId
        ,ua.UserAttributeName
        ,a.AttributePath
        ,ua.CrudIds
        ,(SELECT ua.UserAttributeId AS 'userAttributeId', ua.AttributeId AS 'attributeId', cm.CrudId AS crudId, cm.CrudName AS crudName FROM Crud cm 
                WHERE cm.CrudId IN (SELECT Value FROM STRING_SPLIT( UA.CrudIds, ',')) 
                FOR JSON AUTO) AS AttributeAccessList
        ,umx.CreatedById
        ,umx.CreatedDate
        ,umx.ModifiedById
        ,umx.ModifiedDate
        ,CONCAT(uc.FIRSTNAME, ' ', uc.LastName ) AS CreatedBy
        ,CONCAT(um.FIRSTNAME, ' ', um.LastName ) AS ModifiedBy
        ,ROW_NUMBER() OVER(PARTITION BY umx.RoleId   
                               ORDER BY umx.[CreatedDate] DESC ) AS rk
        FROM UserAccessMatrix umx
        LEFT JOIN Role r on umx.RoleId=r.RoleId
        LEFT JOIN UserAttributes ua on umx.userAttributeId=ua.userAttributeId
        LEFT JOIN Attributes a on ua.AttributeId=a.AttributeId
        LEFT JOIN users uc on umx.CreatedById=uc.UserId
        LEFT JOIN users um on umx.ModifiedById=um.UserId
        WHERE umx.IsActive = 1 AND umx.IsDeleted = 0;

		WITH summary AS (
		 SELECT umx.UserAccessMatrixId
          ,umx.UserAccessDescription
          ,umx.RoleId
          ,r.RoleName
	      ,umx.[CreatedById]
	      ,umx.[CreatedDate]
	      ,umx.[ModifiedById]
	      ,umx.[ModifiedDate]
	      ,umx.IsActive
	     ,CONCAT(uc.FIRSTNAME, ' ', uc.LastName ) AS CreatedBy
	     ,CONCAT(um.FIRSTNAME, ' ', um.LastName ) AS ModifiedBy
         ,(SELECT * FROM @temp t 
		 where 
		 t.roleId = umx.RoleId 
         -- and t.id=1
		  for json auto) as 'UserAttributeDetails'
        ,ROW_NUMBER() OVER(PARTITION BY umx.RoleId   
	                                 ORDER BY umx.[CreatedDate] DESC) AS rk
	  	FROM UserAccessMatrix	umx
	  	INNER JOIN [Role]		r		on r.RoleId			= umx.RoleId
	   	LEFT JOIN users			uc		on umx.CreatedById	= uc.UserId
		LEFT JOIN users			um		on umx.ModifiedById	= um.UserId
        WHERE Upper(umx.UserAccessMatrixId) IN (SELECT upper(userAccessMatrixId) FROM @temp)
   	)

   	SELECT  UserAccessMatrixId
      ,[CreatedById]
      ,[CreatedDate]
      ,[ModifiedById]
      ,[ModifiedDate]
      ,IsActive
     , CreatedBy
     , ModifiedBy
     , RoleId
  	 , RoleName
 	 ,UserAttributeDetails 
	 From summary s 
	 Where s.rk = 1
END


