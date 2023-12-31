USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spDeleteUserAccessMatrix]    Script Date: 05-10-2023 22:04:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[spDeleteUserAccessMatrix]
(  
    @UserAccessMatrixId UNIQUEIDENTIFIER,
    @ModifiedById  UNIQUEIDENTIFIER
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
 
 DECLARE @IsError  BIT  = 0  

  
 BEGIN TRY  
 
    IF  EXISTS(SELECT 1 FROM dbo.UserAccessMatrix WHERE UserAccessMatrixId = @UserAccessMatrixId)
        BEGIN  
                UPDATE dbo.UserAccessMatrix SET IsActive = 0,IsDeleted = 1, DeletedById=@ModifiedById, DeletedDate=GETDATE()
                WHERE UserAccessMatrixId= @UserAccessMatrixId
                
                SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User Matrix is deleted sucessfully' AS ValidateResponse
        END
    ELSE
    BEGIN
		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User Matrix not found' AS ValidateResponse
	END

 END TRY  
 BEGIN CATCH  
  
    SET @IsError = 1;   
    SELECT CONVERT(Varchar,  ERROR_NUMBER()) AS ErrorId, @IsError AS IsError, 
    ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
      
 END CATCH  
  
END  

