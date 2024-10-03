USE TEST_DB
GO
BEGIN TRY
    
	CREATE TABLE Persons (
    PersonID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
	)

END TRY

BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(MAX)
    SET @ErrorMessage = ERROR_MESSAGE()
    
    INSERT INTO TEST_DB.dbo.ErrorLog (ErrorMessage) VALUES (@ErrorMessage)

    RAISERROR(@ErrorMessage, 16, 1);
END CATCH
GO