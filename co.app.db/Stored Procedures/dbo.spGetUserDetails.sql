USE [BaseCrocs]
GO
/****** Object:  StoredProcedure [dbo].[spGetUserDetails]    Script Date: 16-10-2023 12:40:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[spGetUserDetails]
(
	@Username VARCHAR(100),
	@UserIP  VARCHAR(20)
)
AS
BEGIN
	
	DECLARE @SARoleName VARCHAR(50) = 'SAdmin';
	DECLARE @ISSA BIT = 0;
	DECLARE @CurrentUserId UNIQUEIDENTIFIER;
	DECLARE @IsError BIT = 0;
	
	BEGIN TRY

		SELECT @CurrentUserId = UserId FROM Users WHERE UserName = @Username;

		-- Log successfull login

		INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, FailedLoginDate , SuccessLogoffDate , UserAuditDescription)
					VALUES(@CurrentUserId, @UserIP, GETDATE(), NULL, NULL, 'Sucessful login');

		UPDATE Users SET UnsuccessfullCount = 0, IsUserLocked = 0 WHERE UserId = @CurrentUserId;

		-- Get role details

		Select Distinct CONVERT(VARCHAR(MAX), UserId) AS UserId,
		STUFF((Select ','+ CONVERT(VARCHAR(MAX), UR1.RoleId) 
		FROM UserInRole UR1
		LEFT JOIN Role R ON R.RoleId = UR1.RoleId
		WHERE UR1.UserId = UR2.UserId AND UR1.IsActive = 1 AND UR1.DeletedById IS NULL AND UR1.DeletedDate IS NULL 
		AND R.IsActive = 1 AND R.DeletedById IS NULL AND R.DeletedDate IS NULL
		FOR XML PATH('')),1,1,'') AS RoleId
		INTO #TempUserInRole
		FROM UserInRole UR2

		Select Distinct CONVERT(VARCHAR(MAX), UserId) AS UserId ,
		STUFF((Select ','+ CONVERT(VARCHAR(MAX), R.RoleName) 
		FROM UserInRole UR1
		LEFT JOIN Role R ON R.RoleId = UR1.RoleId
		WHERE UR1.UserId = UR2.UserId AND UR1.IsActive = 1 AND UR1.DeletedById IS NULL AND UR1.DeletedDate IS NULL 
		AND R.IsActive = 1 AND R.DeletedById IS NULL AND R.DeletedDate IS NULL
		FOR XML PATH('')),1,1,'') AS RoleNames
		INTO #TempUserInRole2
		FROM UserInRole UR2


		-- Get user group details

		Select Distinct CONVERT(VARCHAR(MAX), UserId) AS UserId,
		STUFF((Select ','+ CONVERT(VARCHAR(MAX), UG.UserGroupId) 
		FROM UserGroup_User UIUG1
		LEFT JOIN UserGroup UG ON UG.UserGroupId = UIUG1.UserGroupId
		WHERE UIUG1.UserId = UIUG2.UserId AND UIUG1.IsActive = 1 AND UIUG1.IsDeleted = 0 
		AND UG.IsActive = 1 AND UG.DeletedById IS NULL AND UG.DeletedDate IS NULL
		FOR XML PATH('')),1,1,'') AS GroupId
		INTO #TempUserInGroup
		FROM UserGroup_User UIUG2

		Select Distinct CONVERT(VARCHAR(MAX), UserId) AS UserId,
		STUFF((Select ','+ CONVERT(VARCHAR(MAX), UG.UserGroupName) 
		FROM UserGroup_User UIUG1
		LEFT JOIN UserGroup UG ON UG.UserGroupId = UIUG1.UserGroupId
		WHERE UIUG1.UserId = UIUG2.UserId AND UIUG1.IsActive = 1 AND UIUG1.IsDeleted = 0
		AND UG.IsActive = 1 AND UG.DeletedById IS NULL AND UG.DeletedDate IS NULL
		FOR XML PATH('')),1,1,'') AS GroupNames
		INTO #TempUserInGroup2
		FROM UserGroup_User UIUG2


		-- Check if Super admin

		IF EXISTS(
			SELECT 1 FROM Users U 
			INNER JOIN UserInRole UIR ON UIR.USERID = U.UserId
			INNER JOIN Role R ON R.RoleId = UIR.ROLEID
			WHERE UserName = @Username and RoleName = @SARoleName
		)

		BEGIN
			SET @ISSA = 1;
		END

		SELECT USR.UserId, USR.UserName, USR.FirstName, USR.Initials, USR.LastName, USR.JobTitle, 
		USR.UserEmail, ISNULL(USR.IsUserLocked, 0) AS  IsUserLocked, USR.IsActive, USR.InactiveDate, 
		USR.InactiveReason, 'Valid user' AS ValidateResponse, 
		0 AS ErrorId, @IsError AS IsError, NULL AS ErrorMessage,
        UIR.RoleId AS RoleIds, UIR2.RoleNames AS RoleNames,
        UIUG.GroupId AS GroupIds, UIUG2.GroupNames AS GroupNames,
        '' AS RefreshToken, '' as Token, NULL AS TokenID,
		USR.CreatedBy, USR.Location, USR.MugShot, NULL AS MugShotImage,
        @ISSA AS ISSA
		FROM		Users			    USR
		LEFT JOIN	#TempUserInRole	    UIR		        ON USR.UserId			= UIR.UserId
        LEFT JOIN	#TempUserInRole2	UIR2		    ON USR.UserId			= UIR2.UserId
        LEFT JOIN	#TempUserInGroup	UIUG		    ON USR.UserId			= UIR.UserId
        LEFT JOIN	#TempUserInGroup2	UIUG2		    ON USR.UserId			= UIR2.UserId
		WHERE 
		USR.IsDeleted = 0 AND USR.IsActive = 1 AND
		USR.UserName = @UserName;


-- spGetUserDetails 'shreyas','::1'

		
	END TRY

	BEGIN CATCH
		SET @IsError = 1;

		SELECT CAST(0x0 AS uniqueidentifier) AS UserId, NULL AS UserName, NULL AS FirstName, NULL AS Initials, NULL AS LastName, NULL AS JobTitle, 
		NULL AS UserEmail, 0 AS IsActive, NULL AS InactiveDate, 
		NULL AS InactiveReason, ERROR_MESSAGE() AS ValidateResponse, 
		ERROR_NUMBER() AS ErrorId, @IsError AS IsError, NULL AS ErrorMessage,
		NULL AS RoleIds,NULL AS RoleNames,
        NULL AS GroupIds, NULL AS GroupNames,
        '' AS RefreshToken,'' as Token, NULL AS TokenID,
		CAST(0x0 AS UNIQUEIDENTIFIER) AS CreatedBy, NULL AS Location, NULL AS MugShot, NULL AS MugShotImage,
        0 AS ISSA;
		
	END CATCH
END
