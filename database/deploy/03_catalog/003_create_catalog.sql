USE MundoEscolar;
GO

-- ============================================================================
-- B. CATÁLOGO
-- ============================================================================

CREATE TABLE dbo.CategoriaProducto (
    IdCategoria INT IDENTITY(1,1) NOT NULL,
    IdCategoriaPadre INT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    Descripcion NVARCHAR(500) NULL,
    CONSTRAINT PK_CategoriaProducto PRIMARY KEY CLUSTERED (IdCategoria),
    CONSTRAINT UQ_CategoriaProducto_PadreNombre UNIQUE NONCLUSTERED (IdCategoriaPadre, Nombre) ON FG_INDEX,
    CONSTRAINT CK_CategoriaProducto_NoAutorreferencia CHECK (IdCategoriaPadre IS NULL OR IdCategoriaPadre <> IdCategoria),
    CONSTRAINT CK_CategoriaProducto_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.Marca (
    IdMarca INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Marca PRIMARY KEY CLUSTERED (IdMarca),
    CONSTRAINT UQ_Marca_Nombre UNIQUE NONCLUSTERED (Nombre) ON FG_INDEX,
    CONSTRAINT CK_Marca_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_Marca_Estado CHECK (Estado IN ('ACTIVO','INACTIVO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.Producto (
    IdProducto INT IDENTITY(1,1) NOT NULL,
    IdCategoria INT NOT NULL,
    IdMarca INT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    Descripcion NVARCHAR(500) NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Producto PRIMARY KEY CLUSTERED (IdProducto),
    CONSTRAINT CK_Producto_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_Producto_Estado CHECK (Estado IN ('ACTIVO','INACTIVO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.Editorial (
    IdEditorial INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    CONSTRAINT PK_Editorial PRIMARY KEY CLUSTERED (IdEditorial),
    CONSTRAINT UQ_Editorial_Nombre UNIQUE NONCLUSTERED (Nombre) ON FG_INDEX,
    CONSTRAINT CK_Editorial_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.Libro (
    IdProducto INT NOT NULL,
    ISBN VARCHAR(20) NULL,
    IdEditorial INT NULL,
    Edicion NVARCHAR(50) NULL,
    AnioPublicacion SMALLINT NULL,
    CONSTRAINT PK_Libro PRIMARY KEY CLUSTERED (IdProducto),
    CONSTRAINT CK_Libro_AnioPublicacion CHECK (AnioPublicacion IS NULL OR AnioPublicacion > 0),
    CONSTRAINT CK_Libro_ISBN_NoVacio CHECK (ISBN IS NULL OR LEN(LTRIM(RTRIM(ISBN))) > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.Autor (
    IdAutor INT IDENTITY(1,1) NOT NULL,
    NombreAutor NVARCHAR(200) NOT NULL,
    CONSTRAINT PK_Autor PRIMARY KEY CLUSTERED (IdAutor),
    CONSTRAINT CK_Autor_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(NombreAutor))) > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.LibroAutor (
    IdProducto INT NOT NULL,
    IdAutor INT NOT NULL,
    OrdenAutoria SMALLINT NOT NULL,
    CONSTRAINT PK_LibroAutor PRIMARY KEY CLUSTERED (IdProducto, IdAutor),
    CONSTRAINT UQ_LibroAutor_Orden UNIQUE NONCLUSTERED (IdProducto, OrdenAutoria) ON FG_INDEX,
    CONSTRAINT CK_LibroAutor_Orden CHECK (OrdenAutoria > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.Presentacion (
    IdPresentacion INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    CantidadBase INT NOT NULL,
    UnidadBase VARCHAR(30) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Presentacion PRIMARY KEY CLUSTERED (IdPresentacion),
    CONSTRAINT CK_Presentacion_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_Presentacion_CantidadBase CHECK (CantidadBase > 0),
    CONSTRAINT CK_Presentacion_UnidadBase_NoVacia CHECK (LEN(LTRIM(RTRIM(UnidadBase))) > 0),
    CONSTRAINT CK_Presentacion_Estado CHECK (Estado IN ('ACTIVO','INACTIVO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.ConceptoComercial (
    IdConceptoComercial INT IDENTITY(1,1) NOT NULL,
    TipoConcepto VARCHAR(20) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_ConceptoComercial PRIMARY KEY CLUSTERED (IdConceptoComercial),
    CONSTRAINT CK_ConceptoComercial_Tipo CHECK (TipoConcepto IN ('ITEM','SERVICIO')),
    CONSTRAINT CK_ConceptoComercial_Estado CHECK (Estado IN ('ACTIVO','INACTIVO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.ItemComercial (
    IdConceptoComercial INT NOT NULL,
    IdProducto INT NOT NULL,
    IdPresentacion INT NOT NULL,
    SKU VARCHAR(50) NOT NULL,
    CodigoBarras VARCHAR(50) NULL,
    CONSTRAINT PK_ItemComercial PRIMARY KEY CLUSTERED (IdConceptoComercial),
    CONSTRAINT UQ_ItemComercial_ProductoPresentacion UNIQUE NONCLUSTERED (IdProducto, IdPresentacion) ON FG_INDEX,
    CONSTRAINT UQ_ItemComercial_SKU UNIQUE NONCLUSTERED (SKU) ON FG_INDEX,
    CONSTRAINT CK_ItemComercial_SKU_NoVacio CHECK (LEN(LTRIM(RTRIM(SKU))) > 0),
    CONSTRAINT CK_ItemComercial_CodigoBarras_NoVacio CHECK (CodigoBarras IS NULL OR LEN(LTRIM(RTRIM(CodigoBarras))) > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.Servicio (
    IdConceptoComercial INT NOT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    Descripcion NVARCHAR(500) NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Servicio PRIMARY KEY CLUSTERED (IdConceptoComercial),
    CONSTRAINT UQ_Servicio_Nombre UNIQUE NONCLUSTERED (Nombre) ON FG_INDEX,
    CONSTRAINT CK_Servicio_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_Servicio_Estado CHECK (Estado IN ('ACTIVO','INACTIVO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.ProveedorItemComercial (
    IdProveedor INT NOT NULL,
    IdItemComercial INT NOT NULL,
    CodigoProveedor VARCHAR(50) NULL,
    EsPreferido BIT NOT NULL CONSTRAINT DF_ProveedorItemComercial_EsPreferido DEFAULT (0),
    CONSTRAINT PK_ProveedorItemComercial PRIMARY KEY CLUSTERED (IdProveedor, IdItemComercial)
) ON FG_DATA;
GO



