USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spGetAllUsers]    Script Date: 11-10-2023 21:19:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
ALTER   PROCEDURE [dbo].[spGetAllUsers] 
(
    @UserId		UNIQUEIDENTIFIER
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @UnSuccessfulCount		INT = 0;
	DECLARE @UnSuccessfulTotalCount INT = 0;
	DECLARE @CurrentUserId			UniqueIdentifier;
	DECLARE @ValidateMessage		VARCHAR(200)	= ''
	DECLARE @IsActive				BIT				= 0; 
	DECLARE @IsUserLocked			BIT				= 0; 
	DECLARE @IsError				BIT				= 0;
	DECLARE @IsLoginFailed			BIT				= 0;
	DECLARE	@IsLogOff				BIT				= 0			
	DECLARE	@IsUserAcceptance		BIT				= 0			
	DECLARE @IsValidUser			BIT				= 0


        SELECT DISTINCT CONVERT(VARCHAR(MAX), UserId) AS UserId ,
        STUFF((Select ','+ CONVERT(VARCHAR(MAX), UR1.RoleId) 
        FROM UserInRole UR1
        LEFT JOIN Role R ON UR1.RoleId = R.RoleId
        WHERE UR1.IsActive = 1 AND R.IsActive = 1
        AND  UR1.UserId = UR2.UserId
        FOR XML PATH('')),1,1,'') AS RoleIds
        INTO #TempUserInRole
        FROM UserInRole UR2

		SELECT USR.UserId
		, USR.UserName
		, NULL AS Password
		, USR.FirstName
		, USR.Initials
		, USR.LastName
		, CONCAT(USR.FirstName,USR.LastName) AS FullName
		, USR.UserEmail
		, USR.PhoneNumber
		, USR.InactiveDate
		, USR.InactiveReason
		, USR.JobTitle
		, USR.IsUserLocked
		, -1 AS UnsuccessfulCount
		, NULL AS WorkIds
		, USR.Gender
		, USR.IsActive, 
		IsNull(UIR.RoleIds,'00000000-0000-0000-0000-000000000000') As RoleIds
		, USR.Location
		, USR.MugShot
		, USR.DefaultAttributeIds
		, USR.CreatedBy
		, USR.CreatedDate
		, USR.ModifiedBy
		, USR.ModifiedDate
		, USR.IsDeleted
		, USR.DeletedBy
		, USR.DeletedDate
		, USR.JobTitle
		FROM		Users			USR
		LEFT JOIN	#TempUserInRole	UIR		ON USR.UserId = UIR.UserId
		WHERE USR.UserId = IIF(@UserId IS NULL OR LEN(LTRIM(RTRIM(@UserId))) = 0, USR.UserId, @UserId)
        AND IsDeleted = 0 AND IsActive = 1
   		ORDER BY USR.FirstName, USR.LastName 
		
END

