USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spCreateTokenInDB]    Script Date: 20-09-2023 19:38:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[spCreateTokenInDB]   
(  
	@GrantedTo		    VARCHAR(max),
	@CurrentToken	    VARCHAR(max),
    @RotativeToken	    VARCHAR(max),
	@TokenValidFrom     DATETIME,
	@TokenValidTo		DATETIME,
	@ClientID		    VARCHAR(100)
)  
AS
BEGIN  
  
  	DECLARE @TokenID	int;
	UPDATE MssToken SET IsDeleted = 1 WHERE GrantedTo = @GrantedTo AND IsDeleted = 0
	INSERT INTO [dbo].[MssToken](
		[GrantedTo], [CurrentToken], [RotativeToken], [TokenValidFrom], [TokenValidTo], [ClientID], [CreatedDate]
	)
	VALUES(
		@GrantedTo, @CurrentToken, @RotativeToken, @TokenValidFrom, @TokenValidTo, @ClientID, GETDATE()
	);

	Set @TokenID = @@IDENTITY;

	SELECT TOP (1) [ID]
      ,[GrantedTo]
      ,[CurrentToken]
      ,[RotativeToken]
      ,[MssSecretID]
	  ,[TokenValidFrom]
	  ,[TokenValidTo]
	  ,[ClientID]
      ,[CreatedDate]
	FROM [dbo].[MssToken] WHERE [ID] = @TokenID;

    
END  
