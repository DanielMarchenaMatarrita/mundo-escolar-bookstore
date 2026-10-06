USE master;
GO

PRINT '=== VALIDATION: MundoEscolar database foundation ===';
GO

/* 1. Database exists */
IF DB_ID(N'MundoEscolar') IS NULL
BEGIN
    THROW 52001, N'Validation failed: database MundoEscolar does not exist.', 1;
END;
GO

/* 2. Recovery model */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE name = N'MundoEscolar'
      AND recovery_model_desc = N'FULL'
)
BEGIN
    THROW 52002, N'Validation failed: MundoEscolar recovery model is not FULL.', 1;
END;
GO

USE MundoEscolar;
GO

/* 3. FG_DATA is DEFAULT */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.filegroups
    WHERE name = N'FG_DATA'
      AND is_default = 1
)
BEGIN
    THROW 52003, N'Validation failed: FG_DATA is not the default filegroup.', 1;
END;
GO

/* 4. Required filegroups exist */
IF NOT EXISTS (SELECT 1 FROM sys.filegroups WHERE name = N'PRIMARY')
    THROW 52004, N'Validation failed: PRIMARY filegroup does not exist.', 1;
GO

IF NOT EXISTS (SELECT 1 FROM sys.filegroups WHERE name = N'FG_DATA')
    THROW 52005, N'Validation failed: FG_DATA filegroup does not exist.', 1;
GO

IF NOT EXISTS (SELECT 1 FROM sys.filegroups WHERE name = N'FG_INDEX')
    THROW 52006, N'Validation failed: FG_INDEX filegroup does not exist.', 1;
GO

IF NOT EXISTS (SELECT 1 FROM sys.filegroups WHERE name = N'FG_AUDIT')
    THROW 52007, N'Validation failed: FG_AUDIT filegroup does not exist.', 1;
GO

/* 5. Physical paths */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_files
    WHERE name = N'MundoEscolar_Primary'
      AND physical_name = N'C:\SQLData\MundoEscolar\Data\MundoEscolar_Primary.mdf'
)
    THROW 52008, N'Validation failed: MundoEscolar_Primary physical path is incorrect.', 1;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_files
    WHERE name = N'MundoEscolar_Data'
      AND physical_name = N'C:\SQLData\MundoEscolar\Data\MundoEscolar_Data.ndf'
)
    THROW 52009, N'Validation failed: MundoEscolar_Data physical path is incorrect.', 1;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_files
    WHERE name = N'MundoEscolar_Index'
      AND physical_name = N'C:\SQLData\MundoEscolar\Index\MundoEscolar_Index.ndf'
)
    THROW 52010, N'Validation failed: MundoEscolar_Index physical path is incorrect.', 1;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_files
    WHERE name = N'MundoEscolar_Audit'
      AND physical_name = N'C:\SQLData\MundoEscolar\Audit\MundoEscolar_Audit.ndf'
)
    THROW 52011, N'Validation failed: MundoEscolar_Audit physical path is incorrect.', 1;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_files
    WHERE name = N'MundoEscolar_Log'
      AND physical_name = N'C:\SQLData\MundoEscolar\Log\MundoEscolar_Log.ldf'
)
    THROW 52012, N'Validation failed: MundoEscolar_Log physical path is incorrect.', 1;
GO

/* 6. Initial sizes */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_files
    WHERE name = N'MundoEscolar_Primary'
      AND size * 8 / 1024 = 64
)
    THROW 52013, N'Validation failed: MundoEscolar_Primary size is not 64 MB.', 1;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_files
    WHERE name = N'MundoEscolar_Data'
      AND size * 8 / 1024 = 256
)
    THROW 52014, N'Validation failed: MundoEscolar_Data size is not 256 MB.', 1;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_files
    WHERE name = N'MundoEscolar_Index'
      AND size * 8 / 1024 = 128
)
    THROW 52015, N'Validation failed: MundoEscolar_Index size is not 128 MB.', 1;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_files
    WHERE name = N'MundoEscolar_Audit'
      AND size * 8 / 1024 = 128
)
    THROW 52016, N'Validation failed: MundoEscolar_Audit size is not 128 MB.', 1;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.database_files
    WHERE name = N'MundoEscolar_Log'
      AND size * 8 / 1024 = 128
)
    THROW 52017, N'Validation failed: MundoEscolar_Log size is not 128 MB.', 1;
GO

PRINT 'PASS: MundoEscolar database foundation is valid.';
GO