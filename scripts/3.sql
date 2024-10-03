USE TEST_DB
GO

BEGIN TRY
    
ALTER TABLE Persons
ADD DateOfBirth date;

END TRY

BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(MAX)
    SET @ErrorMessage = ERROR_MESSAGE()
    
    INSERT INTO TEST_DB.dbo.ErrorLog (ErrorMessage) VALUES (@ErrorMessage)

    RAISERROR(@ErrorMessage, 16, 1);
END CATCH

GO

