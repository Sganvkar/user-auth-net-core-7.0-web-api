USE MSS
GO
CREATE OR ALTER PROCEDURE [dbo].[spGetUserNameByUserGuid] 
(
	@UserGuid		UNIQUEIDENTIFIER
)
AS
BEGIN
	SELECT
        [UserId]
		[UserName]
		,[FirstName]
		,[LastName]
	FROM [dbo].[Users] Where UserId = @UserGuid
END
GO
