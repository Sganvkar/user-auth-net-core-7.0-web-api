USE BaseCrocs
GO
CREATE PROCEDURE [dbo].[spGetRolesFortheUser]
(
    @UserName   VARCHAR(256)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    DECLARE @UserId         UNIQUEIDENTIFIER = NULL;
    DECLARE @RoleId         UNIQUEIDENTIFIER;

    SELECT @UserId = UserId FROM Users WHERE UserName = @UserName AND IsActive = 1
    
	SELECT R.[RoleId]
    ,R.[RoleName]
    ,R.[RoleDescription]
    ,R.[IsActive]
    ,R.[CreatedById]
    ,R.[CreatedDate]
    ,R.[ModifiedById]
    ,R.[ModifiedDate]
    ,R.[DeletedById]
    ,R.[DeletedDate]
    ,CONCAT(U.FIRSTNAME, ' ', U.LastName ) AS CreatedBy
    ,CONCAT(USR.FIRSTNAME, ' ', USR.LastName ) AS ModifiedBy
    ,ISNULL(STUFF((SELECT ','+ LOWER(CONVERT(VARCHAR(MAX), UAM.UserAttributeId))
	FROM UserAccessMatrix UAM
	WHERE UAM.IsActive = 1 AND UAM.DeletedById IS NULL AND UAM.DeletedDate IS NULL
    AND UAM.RoleId = R.RoleId
	FOR XML PATH('')),1,1,''), '') AS UserAttributeIds
	FROM Role R
    LEFT JOIN Users U on R.CreatedById = U.UserId
	LEFT JOIN Users USR on r.ModifiedById = USR.UserId
	WHERE R.IsActive = 1 AND R.DeletedById IS NULL AND R.DeletedDate IS NULL
    AND R.RoleId IN (SELECT RoleId FROM UserInRole WHERE UserId = @UserId AND IsActive = 1)
    ORDER BY R.RoleName ASC
END
GO
