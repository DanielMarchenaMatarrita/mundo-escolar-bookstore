USE MundoEscolar;
GO

-- ============================================================================
-- A. IDENTIDAD COMERCIAL
-- ============================================================================

CREATE TABLE dbo.Tercero (
    IdTercero INT IDENTITY(1,1) NOT NULL,
    TipoIdentificacion VARCHAR(30) NOT NULL,
    NumeroIdentificacion VARCHAR(30) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Tercero PRIMARY KEY CLUSTERED (IdTercero),
    CONSTRAINT UQ_Tercero_Identificacion
        UNIQUE NONCLUSTERED (TipoIdentificacion, NumeroIdentificacion)
        ON FG_INDEX,
    CONSTRAINT CK_Tercero_TipoIdentificacion_NoVacio
        CHECK (LEN(LTRIM(RTRIM(TipoIdentificacion))) > 0),
    CONSTRAINT CK_Tercero_NumeroIdentificacion_NoVacio
        CHECK (LEN(LTRIM(RTRIM(NumeroIdentificacion))) > 0),
    CONSTRAINT CK_Tercero_Estado
        CHECK (Estado IN ('ACTIVO','INACTIVO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.Persona (
    IdTercero INT NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    PrimerApellido NVARCHAR(100) NOT NULL,
    SegundoApellido NVARCHAR(100) NULL,
    CONSTRAINT PK_Persona PRIMARY KEY CLUSTERED (IdTercero),
    CONSTRAINT CK_Persona_Nombre_NoVacio
        CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_Persona_PrimerApellido_NoVacio
        CHECK (LEN(LTRIM(RTRIM(PrimerApellido))) > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.Organizacion (
    IdTercero INT NOT NULL,
    RazonSocial NVARCHAR(200) NOT NULL,
    NombreComercial NVARCHAR(150) NULL,
    CONSTRAINT PK_Organizacion PRIMARY KEY CLUSTERED (IdTercero),
    CONSTRAINT CK_Organizacion_RazonSocial_NoVacia
        CHECK (LEN(LTRIM(RTRIM(RazonSocial))) > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.Cliente (
    IdTercero INT NOT NULL,
    CreditoHabilitado BIT NOT NULL,
    LimiteCredito DECIMAL(19,4) NULL,
    DiasCredito SMALLINT NULL,
    CONSTRAINT PK_Cliente PRIMARY KEY CLUSTERED (IdTercero),
    CONSTRAINT CK_Cliente_Credito CHECK (
        (CreditoHabilitado = 0 AND LimiteCredito IS NULL AND DiasCredito IS NULL)
        OR
        (CreditoHabilitado = 1 AND LimiteCredito > 0 AND DiasCredito > 0)
    )
) ON FG_DATA;
GO

CREATE TABLE dbo.Proveedor (
    IdTercero INT NOT NULL,
    CodigoProveedor VARCHAR(50) NULL,
    EstadoComercial VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Proveedor PRIMARY KEY CLUSTERED (IdTercero),
    CONSTRAINT CK_Proveedor_CodigoProveedor_NoVacio
        CHECK (
            CodigoProveedor IS NULL
            OR LEN(LTRIM(RTRIM(CodigoProveedor))) > 0
        ),
    CONSTRAINT CK_Proveedor_EstadoComercial
        CHECK (EstadoComercial IN ('ACTIVO','SUSPENDIDO','INACTIVO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.ContactoTercero (
    IdContacto INT IDENTITY(1,1) NOT NULL,
    IdTercero INT NOT NULL,
    TipoContacto VARCHAR(20) NOT NULL,
    Valor NVARCHAR(150) NOT NULL,
    Principal BIT NOT NULL
        CONSTRAINT DF_ContactoTercero_Principal DEFAULT (0),
    CONSTRAINT PK_ContactoTercero PRIMARY KEY CLUSTERED (IdContacto),
    CONSTRAINT UQ_ContactoTercero_TipoValor
        UNIQUE NONCLUSTERED (IdTercero, TipoContacto, Valor)
        ON FG_INDEX,
    CONSTRAINT CK_ContactoTercero_TipoContacto_NoVacio
        CHECK (LEN(LTRIM(RTRIM(TipoContacto))) > 0),
    CONSTRAINT CK_ContactoTercero_Valor_NoVacio
        CHECK (LEN(LTRIM(RTRIM(Valor))) > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.DireccionTercero (
    IdDireccion INT IDENTITY(1,1) NOT NULL,
    IdTercero INT NOT NULL,
    Pais NVARCHAR(100) NOT NULL,
    ProvinciaEstado NVARCHAR(100) NOT NULL,
    CantonMunicipio NVARCHAR(100) NOT NULL,
    DistritoLocalidad NVARCHAR(100) NULL,
    DetalleDireccion NVARCHAR(500) NOT NULL,
    Principal BIT NOT NULL
        CONSTRAINT DF_DireccionTercero_Principal DEFAULT (0),
    CONSTRAINT PK_DireccionTercero PRIMARY KEY CLUSTERED (IdDireccion),
    CONSTRAINT CK_DireccionTercero_Pais_NoVacio
        CHECK (LEN(LTRIM(RTRIM(Pais))) > 0),
    CONSTRAINT CK_DireccionTercero_Provincia_NoVacia
        CHECK (LEN(LTRIM(RTRIM(ProvinciaEstado))) > 0),
    CONSTRAINT CK_DireccionTercero_Canton_NoVacio
        CHECK (LEN(LTRIM(RTRIM(CantonMunicipio))) > 0),
    CONSTRAINT CK_DireccionTercero_Detalle_NoVacio
        CHECK (LEN(LTRIM(RTRIM(DetalleDireccion))) > 0)
) ON FG_DATA;
GO