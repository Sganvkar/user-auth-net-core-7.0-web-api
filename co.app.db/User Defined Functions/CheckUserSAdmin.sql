USE [MSS]
GO
/****** Object:  UserDefinedFunction [dbo].[CheckUserSAdmin]    Script Date: 02-10-2023 11:55:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   FUNCTION [dbo].[CheckUserSAdmin](@UserId NVARCHAR(255))
RETURNS INT
AS
BEGIN
	DECLARE @SARoleName VARCHAR(50) = 'SAdmin';
    DECLARE @Result INT = 0;
    
	IF EXISTS( SELECT 1
        FROM Users U
        INNER JOIN UserInRole UIR ON UIR.USERID = U.UserId
        INNER JOIN Role R ON R.RoleId = UIR.ROLEID
        WHERE U.UserId = @UserId AND R.RoleName = @SARoleName)
		
		BEGIN
			RETURN 1;
		END
	
		RETURN 0;
    
END;
