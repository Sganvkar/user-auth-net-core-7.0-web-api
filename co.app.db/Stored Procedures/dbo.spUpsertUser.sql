USE MSS
GO	
CREATE OR ALTER PROCEDURE [dbo].[spUpsertUser] 
(
		@UserId				    UNIQUEIDENTIFIER,
		@UserName			    VARCHAR(100),
		@Password				VARCHAR(50),
		@UserIP				    VARCHAR(50),
		@FirstName			    VARCHAR(200),
		@LastName			    VARCHAR(200),
		@JobTitle			    VARCHAR(200),
		@Location			    VARCHAR(100),
		@MugShot			    VARBINARY(MAX),
		@RoleIds			    VARCHAR(MAX),
        @DefaultAttributeIds    VARCHAR(MAX),
        @IsUserLocked		    BIT,
        @IsActive   		    BIT,
		@CreatedBy			    UNIQUEIDENTIFIER
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT OFF;
	DECLARE @CurrentUserIdTable TABLE (UserId UniqueIdentifier);
	DECLARE @ValidateMessage		VARCHAR(200)	= ''
    DECLARE @ErrorMessage           VARCHAR(200)    = ''
	DECLARE @IsError				BIT				= 0;
	DECLARE @IsLoginFailed			BIT				= 0;
	DECLARE	@IsLogOff				BIT				= 0			
	DECLARE	@IsUserAcceptance		BIT				= 0			
	DECLARE @IsValidUser			BIT				= 0;
	DECLARE @DEFAULTGUID			UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000';
	DECLARE @CurrentUserId UniqueIdentifier;
	
	BEGIN TRY

        -- Insert statements for procedure here
      BEGIN TRANSACTION; 

		-- Check if the user exists
		IF EXISTS(SELECT 1 FROM Users WHERE UserId = @UserId)
		BEGIN
			-- Check for duplicate UserName
			IF EXISTS(SELECT 1 FROM USERS WHERE UserName = @USERNAME AND IsDeleted = 0 AND UserId != @UserId)
			BEGIN
				SET @IsValidUser = 0;

				-- Log the duplicate user
				INSERT INTO UserAudit(UserId, UserIP, FailedLoginDate, UserAuditDescription)
				VALUES(@CreatedBy, @UserIP, GETDATE(), CONCAT('Duplicate user ', @UserName, ' is not allowed'));

				SET @IsError = 1;
        
				-- Return an error message
				SELECT -1 AS ErrorId, @IsError AS IsError, CONCAT('Duplicate user ', @Username, ' is not allowed!!') AS ErrorMessage, 
					   CONCAT('Duplicate user ', @Username, ' is not allowed!!') AS ValidateResponse;
			END
			ELSE
			BEGIN
				SET @IsValidUser = 1;

				-- Update user details
				UPDATE Users 
				SET UserName = @UserName,
					Password = @Password,
					FirstName = @FirstName,
					LastName = @LastName,
					JobTitle = @JobTitle,
					Location = @Location,
					Mugshot = @MugShot,
					DefaultAttributeIds = @DefaultAttributeIds,
					IsUserLocked = @IsUserLocked,
					IsActive = @IsActive,
					ModifiedBy = @CreatedBy,
					ModifiedDate = GETDATE()
				WHERE UserId = @UserId;

				-- Delete roles that are not in the provided list
				DELETE FROM UserInRole
				WHERE UserId = @UserId AND RoleId NOT IN (SELECT VALUE FROM STRING_SPLIT(@RoleIds, ','));

				-- Activate roles that are in the provided list
				UPDATE UserInRole
				SET IsActive = 1, DeletedById = NULL, DeletedDate = NULL
				WHERE UserId = @UserId AND IsActive = 0 AND RoleId IN (SELECT VALUE FROM STRING_SPLIT(@RoleIds, ','));

				-- Insert new roles
				INSERT INTO UserInRole(UserInRoleId, UserId, RoleId, IsActive, CreatedById, CreatedDate, ModifiedById, ModifiedDate)
				SELECT NEWID(), @UserId, VALUE, 1, @CreatedBy, GETDATE(), @CreatedBy, GETDATE()
				FROM STRING_SPLIT(@RoleIds, ',')
				WHERE VALUE NOT IN (SELECT RoleId FROM UserInRole WHERE UserId = @UserId);

				-- Log the successful update
				INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, UserAuditDescription)
				VALUES(@UserId, @UserIP, GETDATE(), CONCAT('Update user ', @UserName, ' successful'));

				SET @IsError = 0;

				-- Return a success message
				SELECT -1 AS ErrorId, @IsError AS IsError, 'No error' AS ErrorMessage, 'User details updated successfully...' AS ValidateResponse;
			END
		END
		ELSE
		BEGIN
			-- User does not exist, check for duplicate UserName
			IF EXISTS(SELECT 1 FROM USERS WHERE UserName = @USERNAME AND IsDeleted = 0)
			BEGIN
				SET @IsValidUser = 0;

				-- Log the duplicate user
				INSERT INTO UserAudit(UserId, UserIP, FailedLoginDate, UserAuditDescription)
				VALUES(@CreatedBy, @UserIP, GETDATE(), CONCAT('Duplicate user ', @UserName, ' is not allowed'));

				SET @IsError = 1;

				-- Return an error message
				SELECT -1 AS ErrorId, @IsError AS IsError, CONCAT('Duplicate user ', @Username, ' is not allowed!!') AS ErrorMessage, 
					   CONCAT('Duplicate user ', @Username, ' is not allowed!!') AS ValidateResponse;
			END
			ELSE
			BEGIN
				SET @IsValidUser = 1;

				-- Create a new user
				INSERT INTO Users(UserName, Password, FirstName, LastName, JobTitle, Location, DefaultAttributeIds, CreatedBy, CreatedDate)
				OUTPUT INSERTED.UserId INTO @CurrentUserIdTable(UserId)
				VALUES(@UserName, @Password, @FirstName, @LastName, @JobTitle, @Location, @DefaultAttributeIds, @CreatedBy, GETDATE());

				SELECT @CurrentUserId = UserId FROM @CurrentUserIdTable;

				-- Log the successful user creation
				INSERT INTO UserAudit(UserId, UserIP, SuccessLoginDate, UserAuditDescription)
				VALUES(@CreatedBy, @UserIP, GETDATE(), CONCAT('Creating new user ', @UserName, ' successful'));

				-- Insert new roles
				INSERT INTO UserInRole(UserInRoleId, UserId, RoleId, IsActive, CreatedById, CreatedDate, ModifiedById, ModifiedDate)
				SELECT NEWID(), @CurrentUserId, VALUE, 1, @CreatedBy, GETDATE(), @CreatedBy, GETDATE()
				FROM STRING_SPLIT(@RoleIds, ',')
				WHERE VALUE NOT IN (SELECT RoleId FROM UserInRole WHERE UserId = @CurrentUserId);

				SET @IsError = 0;

				SELECT -1 AS ErrorId, @IsError AS IsError, 'No error' AS ErrorMessage, 'User details created successfully...' AS ValidateResponse;
			END
		END;

		COMMIT TRANSACTION; -- Commit the transaction

	END TRY
    
	BEGIN CATCH
	ROLLBACK TRANSACTION
		SET @IsError		= 1
		SET @IsLoginFailed	= 1
		SET @IsLogOff		= 1
		SET @IsValidUser	= 0;
		Select ERROR_NUMBER() AS ErrorId, @IsError AS IsError, ERROR_MESSAGE()  AS ErrorMessage, 
		'Error in creating user 'AS ValidateResponse
    END CATCH
		
END

GO
