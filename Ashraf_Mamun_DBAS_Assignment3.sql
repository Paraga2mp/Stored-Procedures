
/*******************************************************************************************************************/
/**********************************Assignment-3: RECORD LOGGING & INSERT/DELETE STORED PROCS ***********************/
/********************************************** Ashraf Mamun (W0425052) ********************************************/
/*******************************************************************************************************************/

USE Chinook;

/* Create a Table name RecordLogging  */

CREATE TABLE RecordLogging (
	
	LogID INTEGER NOT NULL IDENTITY,
	TableName varchar(30),
	RecordID INTEGER,
	ActionType varchar(30) NOT NULL,
	IsError BIT NOT NULL,
	ErrorNum INTEGER,
	LogDate DATETIME NOT NULL,
	PRIMARY KEY (LogID)
);


/* 2. A new stored procedure called uspAddRecordLog will be created, to add logging records and track data changes. */

GO
	CREATE OR ALTER PROC uspAddRecordLog
	---Declaring parameter for this procedure
	(
	 @TableName varchar(120) = NULL,
	 @RecordID int = NULL,
	 @ActionType varchar(30),
	 @ErrorNum int
	)

	AS
	BEGIN
		BEGIN TRANSACTION;
		BEGIN TRY

			/* declares variavles to get system date and set isError value */
			DECLARE @isError BIT
			DECLARE @logDate DATETIME
			SET @LogDate = SYSDATETIME()
			
			/* Compare Error Number and set the ISError variable value */
			IF @ErrorNum <> 0
				SET @isError = 1
			ELSE
				SET @isError = 0

			/* Insert values into RecordLogging table  */
			INSERT INTO Chinook.dbo.RecordLogging
			(
			TableName,
			RecordID,
			ActionType,
			IsError,
			ErrorNum,
			LogDate
			)

			VALUES (
			@TableName,
			@RecordID,
			@ActionType,
			@IsError,
			@ErrorNum,
			@LogDate
			)

		END TRY
		--- If any error occures, execues the catch block immediately to get the error 
		BEGIN CATCH
			SELECT ERROR_NUMBER() AS ErrorNumber
				  ,ERROR_SEVERITY() AS ErrorSeverity
				  ,ERROR_STATE() AS ErrorState
				  ,ERROR_PROCEDURE() AS ErrorProcedures
				  ,ERROR_LINE() AS ErrorLine
				  ,ERROR_MESSAGE() AS ErrorMessage;
			--- If any error occures, rollback the procedure
			IF @@TRANCOUNT > 0
				ROLLBACK TRANSACTION;
		END CATCH
		--- If no error occures, commit the procedure
		IF @@TRANCOUNT > 0
		COMMIT TRANSACTION;	
	END
	
GO


/* 3.	For each of the five tables (Tracks, Artists, Albums, Genres and Mediatypes), 
add a new stored procedure called usp<TableName>_Insert */


/* 3. Declare a procedure name uspArtist_Inserts to insert data into Artist table */

CREATE OR ALTER PROC uspArtist_Inserts
( @Name varchar(120) = null )

AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			--- Insert values into Atrist Table 
			INSERT INTO Chinook.dbo.Artist(Name)
					VALUES (@Name)

				--- Declares variables to get latest ArtistID and set the @Error_Num to 0
				DECLARE @ID int
				SELECT @ID = SCOPE_IDENTITY();
				DECLARE @Error_Num int
				SET @Error_Num = 0

		--- Execute the uspAddRecordLog procedure 
		EXECUTE  uspAddRecordLog 'Artist', @ID, 'INSERT', @Error_Num

		END TRY
		BEGIN CATCH
			---Get the error number and assign to Error_Num variable
			SELECT @Error_Num = ERROR_NUMBER();
			--- Set the @ID variable as -1 when error occures
			SET @ID = -1
			
			--- If error founds, call the uspAddRecordLog procedure and rollback
			ROLLBACK
			EXECUTE  uspAddRecordLog 'Artist', @ID, 'INSERT', @Error_Num
			
		END CATCH

		--- Commit the Transaction
		COMMIT TRANSACTION
	END 
	GO



/* 3. Declare a procedure name uspAlbum_Inserts to insert data into Album table */	
CREATE OR ALTER PROC uspAlbum_Inserts
( @Title varchar(160),
  @ArtistID int 
 )

AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			--- Insert values into Album Table 
			INSERT INTO Chinook.dbo.Album(Title, ArtistId)
					VALUES (@Title, @ArtistID)

				--- Declares variables to get latest AlbumID and set the @Error_Num to 0
				DECLARE @ID int
				SELECT @ID = SCOPE_IDENTITY();
				DECLARE @Error_Num int
				SET @Error_Num = 0
			--- Execute the uspAddRecordLog procedure 
			EXECUTE  uspAddRecordLog 'Album', @ID, 'INSERT', @Error_Num			

		END TRY
		BEGIN CATCH
			---Get the error number and assign to Error_Num variable
			SELECT @Error_Num = ERROR_NUMBER();
			--- Set the @ID variable as -1 when error occures
			SET @ID = -1

			--- If error founds, call the uspAddRecordLog procedure and rollback
			ROLLBACK TRANSACTION
			EXECUTE  uspAddRecordLog 'Album', @ID, 'INSERT', @Error_Num
			
		END CATCH
		--- Commit the Transaction
		COMMIT 
	END 
	GO



/* 3. Declare a procedure name uspMediaType_Inserts to insert data into MediaType table */
CREATE OR ALTER PROC uspMediaType_Inserts
( @Name varchar(120) = null
 )

AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			--- Insert values into MediaType Table 
			INSERT INTO Chinook.dbo.MediaType(Name)
					VALUES (@Name)

			--- Declares variables to get latest AlbumID and set the @Error_Num to 0
			DECLARE @ID int
			SELECT @ID = SCOPE_IDENTITY();
			DECLARE @Error_Num int
			SET @Error_Num = 0

			--- Execute the uspAddRecordLog procedure 
			EXECUTE  uspAddRecordLog 'MediaType', @ID, 'INSERT', @Error_Num

		END TRY
		BEGIN CATCH
			---Get the error number and assign to Error_Num variable
			SELECT @Error_Num = ERROR_NUMBER();
			--- Set the @ID variable as -1 when error occures
			SET @ID = -1

			--- If error founds, call the uspAddRecordLog procedure and rollback
			ROLLBACK
			EXECUTE  uspAddRecordLog 'MediaType', @ID, 'INSERT', @Error_Num
		
		END CATCH

		--- Commit the Transaction
		COMMIT TRANSACTION
	END 
	GO



/* 3. Declare a procedure name uspGenre_Inserts to insert data into Genre table */
CREATE OR ALTER PROC uspGenre_Inserts
( @Name varchar(120) = null
 )

AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			--- Insert values into Genre Table 
			INSERT INTO Chinook.dbo.Genre(Name)
					VALUES (@Name)

			--- Declares variables to get latest GenreID and set the @Error_Num to 0
			DECLARE @ID int
			SELECT @ID = SCOPE_IDENTITY();
			DECLARE @Error_Num int
			SET @Error_Num = 0

			--- Execute the uspAddRecordLog procedure 
			EXECUTE  uspAddRecordLog 'Genre', @ID, 'INSERT', @Error_Num

		END TRY
		BEGIN CATCH
			---Get the error number and assign to Error_Num variable
			SELECT @Error_Num = ERROR_NUMBER();
			--- Set the @ID variable as -1 when error occures
			SET @ID = -1

			--- If error founds, call the uspAddRecordLog procedure and rollback
			ROLLBACK
			EXECUTE  uspAddRecordLog 'Genre', @ID, 'INSERT', @Error_Num
			
		END CATCH
		--- Commit the Transaction
		COMMIT TRANSACTION
	END 
	GO


/* 3. Declare a procedure name uspTrack_Inserts to insert data into Track table */
CREATE OR ALTER PROC uspTrack_Inserts
(	@Name varchar(200),
	@AlbumID int = null,
	@MediaTypeID int,
	@GenreID int = null,
	@Composer varchar(220) = null,
	@Milliseconds int,
	@Bytes int = null,
	@UnitPrice numeric(10,2)
 )

AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			--- Insert values into Track Table 
			INSERT INTO Chinook.dbo.Track(Name, AlbumId, MediaTypeId, GenreId,
			Composer, Milliseconds, Bytes, UnitPrice)
			VALUES (@Name, @AlbumID, @MediaTypeID, @GenreID, @Composer,
			@Milliseconds, @Bytes, @UnitPrice)

			--- Declares variables to get latest TrackID and set the @Error_Num to 0
			DECLARE @ID int
			SELECT @ID = SCOPE_IDENTITY();
			DECLARE @Error_Num int
			SET @Error_Num = 0

			--- Execute the uspAddRecordLog procedure 
			EXECUTE  uspAddRecordLog 'Track', @ID, 'INSERT', @Error_Num

		END TRY
		BEGIN CATCH
			---Get the error number and assign to Error_Num variable
			SELECT @Error_Num = ERROR_NUMBER();
			--- Set the @ID variable as -1 when error occures
			SET @ID = -1

			--- If error founds, call the uspAddRecordLog procedure and rollback
			ROLLBACK
			EXECUTE  uspAddRecordLog 'Track', @ID, 'INSERT', @Error_Num
			
		END CATCH
		--- Commit the Transaction
		COMMIT 
	END 
	GO





/* 4. For each of the five tables (Tracks, Artists, Albums, Genres and Mediatypes), add a new stored 
  procedure called usp<TableName>_DeleteByID */


/* 4. Declare a procedure name uspArtist_DeleteByID to delete data from Artist table */

CREATE OR ALTER PROC uspArtist_DeleteByID
( @ArtistID int )

AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			--- Delete values from Artist Table 
			DELETE FROM Chinook.DBO.Artist
				WHERE ArtistId = @ArtistID

			--- Declares variables to get user entered ID and set the @Error_Num to 0
			DECLARE @ID int
			SELECT @ID = @ArtistID;
			DECLARE @Error_Num int
			SET @Error_Num = 0

			--- Execute the uspAddRecordLog procedure 
			EXECUTE  uspAddRecordLog 'Artist', @ID, 'DELETE', @Error_Num

		END TRY
		BEGIN CATCH
			---Get the error number and assign to Error_Num variable
			SELECT @Error_Num = ERROR_NUMBER();
			--- Set the @ID variable as -1 when error occures
			SET @ID = -1

			--- If error founds, call the uspAddRecordLog procedure and rollback
			ROLLBACK
			EXECUTE  uspAddRecordLog 'Artist', @ID, 'DELETE', @Error_Num
	
		END CATCH

		--- Commit the Transaction
		COMMIT TRANSACTION
	END 
	GO



/* 4. Declare a procedure name uspAlbum_DeleteByID to delete data from Album table */


CREATE OR ALTER PROC uspAlbum_DeleteByID
( @AlbumID int 
)

AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			--- Delete values from Album Table 
			DELETE FROM Chinook.dbo.Album
					WHERE AlbumId = @AlbumID

			--- Declares variables to get user entered ID and set the @Error_Num to 0
			DECLARE @ID int
			SELECT @ID = @AlbumID;
			DECLARE @Error_Num int
			SET @Error_Num = 0
			--- Execute the uspAddRecordLog procedure 
			EXECUTE  uspAddRecordLog 'Album', @ID, 'DELETE', @Error_Num
		
		END TRY
		BEGIN CATCH
			---Get the error number and assign to Error_Num variable
			SELECT @Error_Num = ERROR_NUMBER();
			--- Set the @ID variable as -1 when error occures
			SET @ID = -1

			--- If error founds, call the uspAddRecordLog procedure and rollback
			ROLLBACK TRANSACTION
			EXECUTE  uspAddRecordLog 'Album', @ID, 'DELETE', @Error_Num
			
		END CATCH
		--- Commit the Transaction
		COMMIT 
	END 
	GO



/* 4. Declare a procedure name uspMediaType_DeleteByID to delete data from MediaType table */

CREATE OR ALTER PROC uspMediaType_DeleteByID
( @MediaTypeID int
)

AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			--- Delete values from MediaType Table 
			DELETE FROM Chinook.dbo.MediaType
					WHERE MediaTypeId = @MediaTypeID

			--- Declares variables to get user entered ID and set the @Error_Num to 0
			DECLARE @ID int
			SELECT @ID = @MediaTypeID
			DECLARE @Error_Num int
			SET @Error_Num = 0
			--- Execute the uspAddRecordLog procedure 
			EXECUTE  uspAddRecordLog 'MediaType', @ID, 'DELETE', @Error_Num

		END TRY
		BEGIN CATCH
			---Get the error number and assign to Error_Num variable
			SELECT @Error_Num = ERROR_NUMBER();
			--- Set the @ID variable as -1 when error occures
			SET @ID = -1

			--- If error founds, call the uspAddRecordLog procedure and rollback
			ROLLBACK
			EXECUTE  uspAddRecordLog 'MediaType', @ID, 'DELETE', @Error_Num
			
		END CATCH

		--- Commit the Transaction
		COMMIT TRANSACTION
	END 
	GO


/* 4. Declare a procedure name uspGenre_DeleteByID to delete data from Genre table */

CREATE OR ALTER PROC uspGenre_DeleteByID
( @GenreID int
)

AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			--- Delete values from Genre Table 
			DELETE FROM Chinook.dbo.Genre
					WHERE GenreId = @GenreID

			--- Declares variables to get user entered ID and set the @Error_Num to 0
			DECLARE @ID int
			SELECT @ID = @GenreID;
			DECLARE @Error_Num int
			SET @Error_Num = 0

			--- Execute the uspAddRecordLog procedure 
			EXECUTE  uspAddRecordLog 'Genre', @ID, 'DELETE', @Error_Num

		END TRY
		BEGIN CATCH
			---Get the error number and assign to Error_Num variable
			SELECT @Error_Num = ERROR_NUMBER();
			--- Set the @ID variable as -1 when error occures
			SET @ID = -1

			--- If error founds, call the uspAddRecordLog procedure and rollback
			ROLLBACK
			EXECUTE  uspAddRecordLog 'Genre', @ID, 'DELETE', @Error_Num
			
		END CATCH

		--- Commit the Transaction
		COMMIT TRANSACTION
	END 
	GO


/* 4. Declare a procedure name uspTrack_DeleteByID to delete data from Track table */

CREATE OR ALTER PROC uspTrack_DeleteByID
(	@TrackID int
)

AS
BEGIN
	BEGIN TRANSACTION
		BEGIN TRY
			--- Delete values from Track Table 
			DELETE FROM Chinook.dbo.Track
					WHERE TrackID = @TrackID

			--- Declares variables to get user entered ID and set the @Error_Num to 0
			DECLARE @ID int
			SELECT @ID = @TrackID
			DECLARE @Error_Num int
			SET @Error_Num = 0

			--- Execute the uspAddRecordLog procedure 
			EXECUTE  uspAddRecordLog 'Track', @ID, 'DELETE', @Error_Num

		END TRY
		BEGIN CATCH
			---Get the error number and assign to Error_Num variable
			SELECT @Error_Num = ERROR_NUMBER();
			--- Set the @ID variable as -1 when error occures
			SET @ID = -1

			--- If error founds, call the uspAddRecordLog procedure and rollback
			ROLLBACK
			EXECUTE  uspAddRecordLog 'Track', @ID, 'DELETE', @Error_Num
		 
		END CATCH

		--- Commit the Transaction
		COMMIT 
	END 
	GO



	/* Executing Procs & Testing Statements */



	USE Chinook
	---DELETE FROM RecordLogging WHERE  LogID > 1

	/* Test Insert and Delete Procedute of Artist Table */
	EXECUTE  uspArtist_Inserts @Name = 'LASTADD'

	EXECUTE  uspArtist_DeleteByID @ArtistID = 276

	SELECT * FROM Artist ORDER BY ArtistId DESC

	SELECT * FROM RecordLogging


	/* Test Insert and Delete Procedute of Album Table */
	EXECUTE  uspAlbum_Inserts @Title = 'PPPP', @ArtistID = 43
	
	EXECUTE  uspAlbum_DeleteByID @AlbumID = 348

	SELECT * FROM Album ORDER BY AlbumId DESC

	SELECT * FROM RecordLogging


	/* Test Insert and Delete Procedute of MediaType Table */
	EXECUTE  uspMediaType_Inserts @Name = 'LastAdd'
	
	EXECUTE  uspMediaType_DeleteByID @MediaTypeID = 6

	SELECT * FROM MediaType ORDER BY MediaTypeId DESC

	SELECT * FROM RecordLogging
	
	/* Test Insert and Delete Procedute of Genre Table */
	EXECUTE  uspGenre_Inserts @Name = 'LastAdd'
	
	EXECUTE uspGenre_DeleteByID @GenreID = 26

	SELECT * FROM Genre ORDER BY GenreId DESC

	SELECT * FROM RecordLogging


	/* Test Insert and Delete Procedute of Track Table */
	EXECUTE  uspTrack_Inserts @Name = 'GGG', @AlbumID = 5, @MediaTypeID = 4, 
	@GenreID = 5, @Composer = 'Ashraf', @Milliseconds = 111111, @Bytes = 1111, @UnitPrice = 7.77

	EXECUTE uspTrack_DeleteByID @TrackID = 3504

	SELECT * FROM Track ORDER BY TrackID DESC

	SELECT * FROM RecordLogging


	/* Call Insert Procedure fro Ablum Table with INVALID data  */

	EXECUTE  uspAlbum_Inserts @Title = 'YYYYY', @ArtistID = 999

	SELECT * FROM Album ORDER BY AlbumId DESC

	SELECT * FROM RecordLogging


	/* Call Insert Procedure fro Track Table with INVALID data  */

	EXECUTE  uspTrack_Inserts @Name = 'ZZZZ', @AlbumID = 5, @MediaTypeID = 20, 
	@GenreID = 5, @Composer = 'Ashraf', @Milliseconds = 111111, @Bytes = 1111, @UnitPrice = 5.55

	SELECT * FROM Track ORDER BY TrackID DESC

	SELECT * FROM RecordLogging
	
	
	