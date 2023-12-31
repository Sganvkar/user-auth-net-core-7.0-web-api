USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spDeleteAttribute]    Script Date: 11-10-2023 16:53:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[spDeleteAttribute]
(  
    @AttributeId UniqueIdentifier,
	@DeletedById UniqueIdentifier
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
    SET NOCOUNT ON;  
    DECLARE @IsError BIT = 0  
    BEGIN TRY  
        IF  EXISTS(SELECT 1 FROM UserAttributes WHERE AttributeId = @AttributeId AND IsActive = 1 AND IsDeleted = 0) 
        BEGIN  
            SET @IsError = 1;   
            SELECT -1 AS ErrorId, @IsError AS IsError, 'CANNOT DELETE! Attribute is assigned in Attribute-Access' AS ErrorMessage, 'CANNOT DELETE! Attribute is assigned in Attribute-Access' AS ValidateResponse
        END  
        ELSE
        BEGIN
            IF  EXISTS(SELECT 1 FROM Attributes WHERE AttributeId = @AttributeId) 
            BEGIN  
                UPDATE Attributes SET IsActive = 0, IsDeleted = 1, DeletedById = @DeletedById, DeletedDate = GETDATE() WHERE AttributeId= @AttributeId

                SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'Attribute deleted sucessfully' AS ValidateResponse
        
            END  
            ELSE
            BEGIN
                SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'Attribute not found' AS ValidateResponse
                
            END
        END
    
    END TRY  
        
    BEGIN CATCH  

        SET @IsError = 1;   
        SELECT CONVERT(Varchar,  ERROR_NUMBER()) AS ErrorId, @IsError AS IsError, 
        ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
        
    END CATCH  
  
END  
