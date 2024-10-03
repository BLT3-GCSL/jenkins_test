USE TEST_DB
GO
BEGIN TRY
    
	CREATE TABLE [dbo].[AssetMaster](
	[AssetCode] [nvarchar](15) NOT NULL,
	[AssetName] [nvarchar](70) NULL,
	[AssetDescription] [nvarchar](100) NULL,
	[AssetType] [nvarchar](15) NULL,
	[AssetOwnerShip] [nvarchar](10) NULL,
	[AssetLocation] [nvarchar](50) NULL,
	[AssetNotes] [ntext] NULL,
	[AssetAssignedEmpNo] [bigint] NULL,
	[AssetAssignedName] [nvarchar](50) NULL,
	[AssetStatus] [bit] NULL,
	[AssetStatusRemarks] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

END TRY

BEGIN CATCH
    DECLARE @ErrorMessage NVARCHAR(MAX)
    SET @ErrorMessage = ERROR_MESSAGE()
    
    INSERT INTO TEST_DB.dbo.ErrorLog (ErrorMessage) VALUES (@ErrorMessage)

    RAISERROR(@ErrorMessage, 16, 1);
END CATCH

GO