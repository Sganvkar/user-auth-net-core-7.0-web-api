USE [BaseCrocs]
GO
/****** Object:  StoredProcedure [dbo].[spCreateTokenInDB]    Script Date: 16-10-2023 12:37:56 ******/
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
  
  	DECLARE @TokenID UNIQUEIDENTIFIER;
	SET @TokenID = NEWID();

	UPDATE Token SET IsDeleted = 1 WHERE GrantedTo = @GrantedTo AND IsDeleted = 0
	INSERT INTO [dbo].[Token](
		[Id], [GrantedTo], [CurrentToken], [RotativeToken], [TokenValidFrom], [TokenValidTo], [ClientID], [CreatedDate]
	)
	VALUES(
		@TokenID, @GrantedTo, @CurrentToken, @RotativeToken, @TokenValidFrom, @TokenValidTo, @ClientID, GETDATE()
	);


	SELECT TOP (1) [ID]
      ,[GrantedTo]
      ,[CurrentToken]
      ,[RotativeToken]
      ,[MssSecretID]
	  ,[TokenValidFrom]
	  ,[TokenValidTo]
	  ,[ClientID]
      ,[CreatedDate]
	FROM [dbo].[Token] WHERE [ID] = @TokenID AND [IsDeleted] = 0;

    
END  
