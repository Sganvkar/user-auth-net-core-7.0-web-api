USE
Logs
GO

CREATE TABLE AuditLog (
    AuditLogId INT IDENTITY(1,1) PRIMARY KEY,
    AuditLogObjectName NVARCHAR(100),
    ClientComputerName NVARCHAR(100),
    ObjectGUID UNIQUEIDENTIFIER NULL,
    ShortDescription NVARCHAR(200),
    Details NVARCHAR(MAX),
    ObjectID BIGINT NULL,
    UserName NVARCHAR(100),
    UserGUID UNIQUEIDENTIFIER NULL,
    ClientIP NVARCHAR(50) NULL
);
