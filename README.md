# net-core-7.0-web-api
A base for a .Net Core 7.0 Web API, which includes JWT based User Authentication, Role Based Access and Database Logging.

## Folder Structure:

1)co.app.common(.Net Class Library)
  -  Definitions   : EntityFrameworkCore Class files
  -  WebApi        : EntityFrameworkCore Class files
  -  Constants.cs  : Common constants
  -  Helper.cs     : Helper functions
    
2)co.app.db
  -  Db Create Scripts
  -  Stored Procedures
  -  Tables
  -  User defined tables
  -  User defined functions
    
3)co.app.solution 
  -  co.app.api    : Contains the api files

## Installation instructions:

1. Clone the repo from [https://github.com/Sganvkar/net-core-7.0-web-api.git](url)
2. Open the root folder in VS Code (pref. 2022)
3. Build co.app.common solution
4. Build the co.app.api solution
5. Run on IIS Express.

## Environment

Windows 11, VS Studio 2022, SSMS 2018  
