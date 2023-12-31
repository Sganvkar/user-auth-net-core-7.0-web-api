USE [BaseCrocs]
GO
/****** Object:  StoredProcedure [dbo].[spGetTokenByTokenID]    Script Date: 16-10-2023 12:20:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spGetTokenByTokenID] 
(    
  @TokenID  UNIQUEIDENTIFIER
)    
AS    

BEGIN
    
	SELECT TOP (1) [ID]
      ,[GrantedTo]
      ,[CurrentToken]
      ,[RotativeToken]
      ,[MssSecretID]
	  ,[TokenValidFrom]
	  ,[TokenValidTo]
	  ,[ClientID]
      ,[CreatedDate]
	FROM [dbo].[Token] WHERE [ID] = @TokenID AND (IsDeleted IS NULL OR IsDeleted = 0);

END 
