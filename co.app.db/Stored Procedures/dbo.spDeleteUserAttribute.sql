USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spDeleteUserAttribute]    Script Date: 05-10-2023 20:31:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[spDeleteUserAttribute]  
(    
    @UserAttributeId UNIQUEIDENTIFIER,  
    @ModifiedById  UNIQUEIDENTIFIER  
)    
AS    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from    
 -- interfering with SELECT statements.    
 SET NOCOUNT ON;    
   
 DECLARE @IsError  BIT  = 0    
    
 BEGIN TRY   
	BEGIN TRANSACTION
    IF EXISTS (SELECT 1 FROM dbo.UserAccessMatrix WHERE UserAttributeId= @UserAttributeId AND IsActive = 1 AND IsDeleted=0)  
    BEGIN  

        SET @IsError = 1;
        SELECT -1 AS ErrorId, @IsError as IsError, 'CANNOT DELETE! Attribute-Access is assigned in User Access Matrix' AS ErrorMessage, 'CANNOT DELETE! Attribute-Access is assigned in Role Access Matrix' AS ValidateResponse

    END    
    ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM UserAttributes WHERE UserAttributeId= @UserAttributeId)  
        BEGIN  

			DELETE FROM UserAccessMatrix WHERE UserAttributeId = @UserAttributeId;

			DELETE FROM UserAttributes WHERE UserAttributeId = @UserAttributeId;

            SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User Attribute deleted sucessfully' AS ValidateResponse

        END    
        ELSE  
        BEGIN  
            SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User Attribute not found' AS ValidateResponse
        END  
    END
    COMMIT TRANSACTION
 END TRY    
        
 BEGIN CATCH    
    ROLLBACK TRANSACTION
    SET @IsError = 1;     
    SELECT CONVERT(Varchar,  ERROR_NUMBER()) AS ErrorId, @IsError AS IsError,   
    ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
        
 END CATCH    
    
END 
