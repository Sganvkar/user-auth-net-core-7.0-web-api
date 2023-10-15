CREATE PROCEDURE [dbo].[spGetMssTokenByTokenID] 
(    
  @TokenID  INT
)    
AS    
-- spGetEMRtokenByTokenID 143
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
	FROM [dbo].[MssToken] WHERE [ID] = @TokenID AND (IsDeleted IS NULL OR IsDeleted = 0);

END 
GO
