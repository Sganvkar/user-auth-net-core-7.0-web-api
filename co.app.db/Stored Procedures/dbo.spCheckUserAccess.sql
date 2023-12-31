USE [MSS]
GO
/****** Object:  StoredProcedure [dbo].[spCheckUserAccess]    Script Date: 14-10-2023 19:47:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER   PROCEDURE [dbo].[spCheckUserAccess]
(
	@AccessedById	UNIQUEIDENTIFIER,
	@AttributePath	VARCHAR(100),
	@CrudName		VARCHAR(10) = NULL
)
AS
BEGIN

	-- spCheckUserAccess '0FA9B4E3-9556-4E3A-AAA9-5885B3FDAB13','/test'
	BEGIN TRY

	DECLARE @IsError			BIT = 0;
	DECLARE @SARoleName			VARCHAR(50) = 'SAdmin';
	DECLARE @AllAccess			VARCHAR(100);
	DECLARE @AllAccessCount		INT = 0;
	DECLARE @DefaultAttrTable	TABLE 
    ( 
        AttributeId   UNIQUEIDENTIFIER,
        CrudIds           VARCHAR(MAX)
    )
	DECLARE @DfltCrudIds		VARCHAR(100);
	DECLARE @AllAccess_DA		VARCHAR(100);
	DECLARE @AllAccessCount_DA	INT = 0;
	DECLARE @JoinedCN           VARCHAR(MAX);
	DECLARE @CID                UNIQUEIDENTIFIER = NULL;



	SELECT @AllAccess = STRING_AGG(CrudName, ',') FROM Crud;
	SET @AllAccess = COALESCE(@AllAccess, '');

	SELECT @AllAccessCount = COUNT(*) FROM Crud

    SELECT @CID= CrudId FROM Crud WHERE CrudName = @CrudName;

	IF [dbo].[CheckUserSAdmin](@AccessedById) = 1 
		BEGIN
			 SELECT @AllAccessCount AS TotalAccessCount, @AllAccess AS AccessLevels,
            -1 AS ErrorId, @IsError AS IsError, 
            'No error' As ErrorMessage, 
            'No error in checking user access' AS ValidateResponse
		END
	ELSE
		BEGIN
			INSERT INTO @DefaultAttrTable
			SELECT AttributeId, CrudIds FROM UserAttributes 
			WHERE UserAttributeId IN 
			(
				SELECT Value
				FROM STRING_SPLIT(
					(
						SELECT IIF(LTRIM(RTRIM(DefaultAttributeIds)) = '', NULL, DefaultAttributeIds)
						FROM Users
						WHERE UserId = @AccessedById AND IsActive = 1
					),
					','
				)
			);

			IF EXISTS(SELECT TOP 1 * FROM @DefaultAttrTable)
				BEGIN

					SELECT @DfltCrudIds = CrudIds FROM @DefaultAttrTable 
					WHERE AttributeId IN 
					( 
						SELECT AttributeId FROM Attributes
						WHERE AttributeName = @AttributePath
						AND IsActive = 1 AND IsDeleted = 0
					);

					
					SELECT @AllAccess_DA = STRING_AGG(CrudName, ', ') 
					FROM Crud 
					WHERE CrudId IN (SELECT VALUE FROM STRING_SPLIT(@DfltCrudIds, ','))
					AND (@CID IS NULL OR @CID IN (SELECT VALUE FROM STRING_SPLIT(@DfltCrudIds, ',')))


					SELECT @AllAccessCount_DA = COUNT(*) FROM STRING_SPLIT(@DfltCrudIds, ',');


					SELECT @AllAccessCount_DA AS TotalAccessCount, @AllAccess_DA AS AccessLevels,
					-1 AS ErrorId, @IsError AS IsError, 
					'No error' As ErrorMessage, 
					'No error in checking user access' AS ValidateResponse

				END

			ELSE
				BEGIN

					DECLARE @CurrentUserRoleId UNIQUEIDENTIFIER;

					SELECT @CurrentUserRoleId = RoleId
					FROM UserInRole
					WHERE UserId = @AccessedById;

					WITH FilteredAttributes AS (
						SELECT UA.AttributeId, UA.CrudIds, A.AttributePath
						FROM UserAttributes UA
						LEFT JOIN Attributes A ON UA.AttributeId = A.AttributeId
						WHERE EXISTS (
							SELECT 1
							FROM Attributes
							WHERE AttributeId = UA.AttributeId
							AND AttributePath = @AttributePath
							AND IsActive = 1
							AND IsDeleted = 0
						)
						AND EXISTS (
							SELECT 1
							FROM UserAccessMatrix
							WHERE IsActive = 1
							AND RoleId = @CurrentUserRoleId
							AND UserAttributeId = UA.UserAttributeId
						)
					)

					SELECT *
					INTO #TempTable
					FROM FilteredAttributes;


					SELECT DISTINCT
					t1.AttributePath,
					STUFF(
						(
							SELECT ',' + STUFF(
								(
									SELECT ',' + CT.CrudName
									FROM Crud AS CT
									WHERE CT.CrudId IN (SELECT Value FROM STRING_SPLIT(t2.CrudIds, ','))
									AND (@CID IS NULL OR @CID IN (SELECT VALUE FROM STRING_SPLIT(t2.CrudIds, ',')))
									FOR XML PATH('')
								), 1, 1, ''
							)
							FROM #TempTable AS t2
							WHERE t2.AttributePath = t1.AttributePath
							FOR XML PATH('')
						), 1, 1, ''
					) AS JoinedCN
					INTO #TempTable2
					FROM #TempTable AS t1;

				SELECT @JoinedCN = JoinedCN FROM #TempTable2;

				IF @JoinedCN IS NOT NULL
					BEGIN

						SELECT 0 AS AccessCount, count(*) AS TotalAccessCount, IIF(@JoinedCN IS NULL, '', @JoinedCN) AS AccessLevels,
						-1 AS ErrorId, @IsError AS IsError, 
						'No error' As ErrorMessage, 
						'No error in checking user access' AS ValidateResponse

					END
				ELSE 
					BEGIN
						
						SELECT 0 AS AccessCount, 0 AS TotalAccessCount, '' AS AccessLevels,
						-1 AS ErrorId, @IsError AS IsError, 
						'No error' As ErrorMessage, 
						'User does not have access!!!' AS ValidateResponse

					END
				
				
                                        

				END
			
			
		END

		-- spCheckUserAccess '8ABC7E7E-5316-4F79-8FA0-884D7FD804C7','/test-path121'

	END TRY

	BEGIN CATCH
		SET @IsError = 1;
		SELECT 0 AS AccessCount, 0 As TotalAccessCount, '' AS AccessLevels,
		-1 AS ErrorId, 
		@IsError AS IsError, 
		ERROR_MESSAGE() As ErrorMessage, 
		ERROR_MESSAGE() AS ValidateResponse	
	END CATCH
END

