USE master;
GO

IF DB_ID(N'MundoEscolar') IS NOT NULL
BEGIN
    THROW 51010,
        N'La base MundoEscolar ya existe. Fase 5.3B requiere una creación limpia para validar archivos y filegroups.',
        1;
END;
GO

CREATE DATABASE MundoEscolar
ON
PRIMARY
(
    NAME = N'MundoEscolar_Primary',
    FILENAME = N'C:\SQLData\MundoEscolar\Data\MundoEscolar_Primary.mdf',
    SIZE = 64MB,
    MAXSIZE = 1024MB,
    FILEGROWTH = 64MB
),
FILEGROUP FG_DATA
(
    NAME = N'MundoEscolar_Data',
    FILENAME = N'C:\SQLData\MundoEscolar\Data\MundoEscolar_Data.ndf',
    SIZE = 256MB,
    MAXSIZE = 8192MB,
    FILEGROWTH = 128MB
),
FILEGROUP FG_INDEX
(
    NAME = N'MundoEscolar_Index',
    FILENAME = N'C:\SQLData\MundoEscolar\Index\MundoEscolar_Index.ndf',
    SIZE = 128MB,
    MAXSIZE = 4096MB,
    FILEGROWTH = 64MB
),
FILEGROUP FG_AUDIT
(
    NAME = N'MundoEscolar_Audit',
    FILENAME = N'C:\SQLData\MundoEscolar\Audit\MundoEscolar_Audit.ndf',
    SIZE = 128MB,
    MAXSIZE = 8192MB,
    FILEGROWTH = 64MB
)
LOG ON
(
    NAME = N'MundoEscolar_Log',
    FILENAME = N'C:\SQLData\MundoEscolar\Log\MundoEscolar_Log.ldf',
    SIZE = 128MB,
    MAXSIZE = 4096MB,
    FILEGROWTH = 64MB
);
GO

ALTER DATABASE MundoEscolar
MODIFY FILEGROUP FG_DATA DEFAULT;
GO

ALTER DATABASE MundoEscolar
SET RECOVERY FULL;
GO
