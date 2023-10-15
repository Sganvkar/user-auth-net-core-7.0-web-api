USE 
Logs
GO
CREATE PROCEDURE spInsertExceptionLog
    @ClassName NVARCHAR(MAX),
    @MethodName NVARCHAR(MAX),
    @Message NVARCHAR(MAX),
    @Code NVARCHAR(MAX),
    @UserGUID NVARCHAR(MAX),
    @UserName NVARCHAR(MAX),
    @ClientIP NVARCHAR(MAX),
    @ClientComputerName NVARCHAR(MAX)
AS
BEGIN
    INSERT INTO ExceptionLog (ClassName, MethodName, Message, Code, UserGUID, UserName, ClientIP, ClientComputerName)
    VALUES (@ClassName, @MethodName, @Message, @Code, @UserGUID, @UserName, @ClientIP, @ClientComputerName);
END;






