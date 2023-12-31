USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spInsertEnquiryData]    Script Date: 20-03-2023 23:45:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[spInsertEnquiryData] 
	(
        @Name VARCHAR(50),
        @PhoneNumber VARCHAR(50),
        @AlternatePhoneNumber VARCHAR(50),
        @Email VARCHAR(50),
        @EnquiryDescription VARCHAR(500),
        @EnquiredProduct VARCHAR(500)
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @IsError BIT = 0;
	DECLARE @InsertOutput TABLE
	(
	  InsertedEnquiryID UNIQUEIDENTIFIER
	)
	DECLARE @EnquiryID UNIQUEIDENTIFIER;

	BEGIN TRY
		INSERT INTO [dbo].[Enquiries]
           ([EnquiryID]
           ,[Name]
           ,[PhoneNumber]
           ,[AlternatePhoneNumber]
           ,[Email]
           ,[EnquiryDescription]
           ,[EnquiredProduct]
		   ,[CreatedDate])
		OUTPUT INSERTED.EnquiryID INTO @InsertOutput
		VALUES
           (NEWID()
           ,@Name
           ,@PhoneNumber
           ,@AlternatePhoneNumber
           ,@Email
           ,@EnquiryDescription
           ,@EnquiredProduct
		   ,GETDATE())

		SELECT @EnquiryID = InsertedEnquiryID FROM @InsertOutput;

		SELECT 0 AS ErrorId, @IsError as IsError, NULL AS ErrorMessage, NULL AS ValidateResponse, ObjectGuid = @EnquiryID;
	END TRY
	BEGIN CATCH
		SET @IsError = 1
		SELECT ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE() AS ErrorMessage, ERROR_MESSAGE() AS ValidateResponse, EnquiryID = NULL;
	END CATCH
	
END
