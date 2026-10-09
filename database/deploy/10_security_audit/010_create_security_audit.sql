USE MundoEscolar;
GO

-- ============================================================================
-- I. SEGURIDAD Y AUDITORÍA
-- ============================================================================

CREATE TABLE dbo.Usuario (
    IdUsuario INT IDENTITY(1,1) NOT NULL,
    IdPersona INT NULL,
    NombreUsuario NVARCHAR(100) NOT NULL,
    Credencial VARCHAR(255) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Usuario PRIMARY KEY CLUSTERED (IdUsuario),
    CONSTRAINT UQ_Usuario_NombreUsuario UNIQUE NONCLUSTERED (NombreUsuario) ON FG_INDEX,
    CONSTRAINT CK_Usuario_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(NombreUsuario))) > 0),
    CONSTRAINT CK_Usuario_Credencial_NoVacia CHECK (LEN(LTRIM(RTRIM(Credencial))) > 0),
    CONSTRAINT CK_Usuario_Estado CHECK (Estado IN ('ACTIVO','INACTIVO','BLOQUEADO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.Rol (
    IdRol INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(500) NULL,
    CONSTRAINT PK_Rol PRIMARY KEY CLUSTERED (IdRol),
    CONSTRAINT UQ_Rol_Nombre UNIQUE NONCLUSTERED (Nombre) ON FG_INDEX,
    CONSTRAINT CK_Rol_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.Permiso (
    IdPermiso INT IDENTITY(1,1) NOT NULL,
    Codigo VARCHAR(50) NOT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    Descripcion NVARCHAR(500) NULL,
    CONSTRAINT PK_Permiso PRIMARY KEY CLUSTERED (IdPermiso),
    CONSTRAINT UQ_Permiso_Codigo UNIQUE NONCLUSTERED (Codigo) ON FG_INDEX,
    CONSTRAINT CK_Permiso_Codigo_NoVacio CHECK (LEN(LTRIM(RTRIM(Codigo))) > 0),
    CONSTRAINT CK_Permiso_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.UsuarioRol (
    IdUsuario INT NOT NULL,
    IdRol INT NOT NULL,
    CONSTRAINT PK_UsuarioRol PRIMARY KEY CLUSTERED (IdUsuario, IdRol)
) ON FG_DATA;
GO

CREATE TABLE dbo.RolPermiso (
    IdRol INT NOT NULL,
    IdPermiso INT NOT NULL,
    CONSTRAINT PK_RolPermiso PRIMARY KEY CLUSTERED (IdRol, IdPermiso)
) ON FG_DATA;
GO

CREATE TABLE dbo.RegistroAuditoria (
    IdAuditoria INT IDENTITY(1,1) NOT NULL,
    IdUsuario INT NULL,
    Fecha DATETIME2(0) NOT NULL,
    Accion VARCHAR(30) NOT NULL,
    Entidad VARCHAR(100) NOT NULL,
    ReferenciaRegistro NVARCHAR(100) NOT NULL,
    Campo VARCHAR(100) NULL,
    ValorAnterior NVARCHAR(1000) NULL,
    ValorNuevo NVARCHAR(1000) NULL,
    CONSTRAINT PK_RegistroAuditoria PRIMARY KEY CLUSTERED (IdAuditoria),
    CONSTRAINT CK_RegistroAuditoria_Accion_NoVacia CHECK (LEN(LTRIM(RTRIM(Accion))) > 0),
    CONSTRAINT CK_RegistroAuditoria_Entidad_NoVacia CHECK (LEN(LTRIM(RTRIM(Entidad))) > 0),
    CONSTRAINT CK_RegistroAuditoria_Referencia_NoVacia CHECK (LEN(LTRIM(RTRIM(ReferenciaRegistro))) > 0)
) ON FG_AUDIT;
GO



