USE
Logs

CREATE TABLE ExceptionLog (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    ClassName VARCHAR(100),
    MethodName VARCHAR(100),
    Message VARCHAR(MAX),
    Code VARCHAR(MAX),
    UserGUID VARCHAR(50),
    UserName VARCHAR(50),
    ClientIP VARCHAR(50),
    ClientComputerName VARCHAR(50),
    LogTimestamp DATETIME DEFAULT GETDATE()
);



