USE MSS
GO
CREATE OR ALTER PROCEDURE [dbo].[spDeleteUser]
(  
    @UserId         UNIQUEIDENTIFIER,
    @ModifiedById   UNIQUEIDENTIFIER
)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
    SET NOCOUNT ON;  

    DECLARE @IsError  BIT  = 0  
  
    BEGIN TRY  

    IF  EXISTS(SELECT 1 FROM Users WHERE UserId= @UserId)
    BEGIN  

        UPDATE Users SET IsActive = 0, IsDeleted = 1, DeletedBy = @ModifiedById, DeletedDate = GETDATE()
        WHERE UserId= @UserId
        
        SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User deleted sucessfully' AS ValidateResponse  

    END  
    ELSE
    BEGIN

        SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, 'User not found' AS ValidateResponse

    END

    END TRY  
      
    BEGIN CATCH  
  
        SET @IsError = 1;   
        SELECT CONVERT(Varchar,  ERROR_NUMBER()) AS ErrorId, @IsError AS IsError, 
        ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse
      
    END Catch  
  
END  

GO
