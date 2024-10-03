USE TEST_DB
GO

/****** Object:  Table [dbo].[AssetMaster]    Script Date: 8/22/2024 1:59:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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

GO