USE MundoEscolar;
GO

-- ============================================================================
-- E. INVENTARIO
-- ============================================================================

CREATE TABLE dbo.Sucursal (
    IdSucursal INT IDENTITY(1,1) NOT NULL,
    Codigo VARCHAR(50) NOT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    Provincia NVARCHAR(100) NOT NULL,
    Canton NVARCHAR(100) NOT NULL,
    Distrito NVARCHAR(100) NULL,
    DireccionExacta NVARCHAR(500) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Sucursal PRIMARY KEY CLUSTERED (IdSucursal),
    CONSTRAINT UQ_Sucursal_Codigo UNIQUE NONCLUSTERED (Codigo) ON FG_INDEX,
    CONSTRAINT CK_Sucursal_Codigo_NoVacio CHECK (LEN(LTRIM(RTRIM(Codigo))) > 0),
    CONSTRAINT CK_Sucursal_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_Sucursal_Provincia_NoVacia CHECK (LEN(LTRIM(RTRIM(Provincia))) > 0),
    CONSTRAINT CK_Sucursal_Canton_NoVacio CHECK (LEN(LTRIM(RTRIM(Canton))) > 0),
    CONSTRAINT CK_Sucursal_Direccion_NoVacia CHECK (LEN(LTRIM(RTRIM(DireccionExacta))) > 0),
    CONSTRAINT CK_Sucursal_Estado CHECK (Estado IN ('ACTIVO','INACTIVO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.UbicacionInventario (
    IdUbicacion INT IDENTITY(1,1) NOT NULL,
    IdSucursal INT NOT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    Descripcion NVARCHAR(500) NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_UbicacionInventario PRIMARY KEY CLUSTERED (IdUbicacion),
    CONSTRAINT UQ_UbicacionInventario_SucursalNombre UNIQUE NONCLUSTERED (IdSucursal, Nombre) ON FG_INDEX,
    CONSTRAINT CK_UbicacionInventario_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_UbicacionInventario_Estado CHECK (Estado IN ('ACTIVO','INACTIVO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.MovimientoInventario (
    IdMovimiento INT IDENTITY(1,1) NOT NULL,
    IdUsuario INT NOT NULL,
    TipoMovimiento VARCHAR(30) NOT NULL,
    Fecha DATETIME2(0) NOT NULL,
    Motivo NVARCHAR(500) NULL,
    CONSTRAINT PK_MovimientoInventario PRIMARY KEY CLUSTERED (IdMovimiento),
    CONSTRAINT CK_MovimientoInventario_Tipo CHECK (
        TipoMovimiento IN ('COMPRA','VENTA','DEVOLUCION','MERMA','TRASLADO','AJUSTE_CONTEO','AJUSTE_MANUAL')
    )
) ON FG_DATA;
GO

CREATE TABLE dbo.DetalleMovimientoInventario (
    IdMovimiento INT NOT NULL,
    IdItemComercial INT NOT NULL,
    IdUbicacion INT NOT NULL,
    Cantidad INT NOT NULL,
    CONSTRAINT PK_DetalleMovimientoInventario PRIMARY KEY CLUSTERED (IdMovimiento, IdItemComercial, IdUbicacion),
    CONSTRAINT CK_DetalleMovimientoInventario_Cantidad CHECK (Cantidad <> 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.Existencia (
    IdItemComercial INT NOT NULL,
    IdUbicacion INT NOT NULL,
    CantidadActual INT NOT NULL,
    FechaActualizacion DATETIME2(0) NOT NULL,
    CONSTRAINT PK_Existencia PRIMARY KEY CLUSTERED (IdItemComercial, IdUbicacion),
    CONSTRAINT CK_Existencia_Cantidad CHECK (CantidadActual >= 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.ConteoInventario (
    IdConteo INT IDENTITY(1,1) NOT NULL,
    IdUbicacion INT NOT NULL,
    IdUsuario INT NOT NULL,
    FechaInicio DATETIME2(0) NOT NULL,
    FechaCierre DATETIME2(0) NULL,
    FechaAprobacion DATETIME2(0) NULL,
    Estado VARCHAR(20) NOT NULL,
    IdMovimientoAjuste INT NULL,
    CONSTRAINT PK_ConteoInventario PRIMARY KEY CLUSTERED (IdConteo),
    CONSTRAINT CK_ConteoInventario_Fechas CHECK (
        (FechaCierre IS NULL OR FechaCierre >= FechaInicio)
        AND
        (FechaAprobacion IS NULL OR (FechaCierre IS NOT NULL AND FechaAprobacion >= FechaCierre))
    ),
    CONSTRAINT CK_ConteoInventario_Estado CHECK (Estado IN ('ABIERTO','CERRADO','APROBADO','ANULADO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.LineaConteo (
    IdConteo INT NOT NULL,
    IdItemComercial INT NOT NULL,
    CantidadEsperada INT NOT NULL,
    CantidadFisica INT NOT NULL,
    CONSTRAINT PK_LineaConteo PRIMARY KEY CLUSTERED (IdConteo, IdItemComercial),
    CONSTRAINT CK_LineaConteo_Cantidades CHECK (CantidadEsperada >= 0 AND CantidadFisica >= 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.ReglaReposicion (
    IdItemComercial INT NOT NULL,
    IdUbicacion INT NOT NULL,
    StockMinimo INT NOT NULL,
    PuntoReposicion INT NOT NULL,
    StockObjetivo INT NOT NULL,
    CONSTRAINT PK_ReglaReposicion PRIMARY KEY CLUSTERED (IdItemComercial, IdUbicacion),
    CONSTRAINT CK_ReglaReposicion_Rangos CHECK (
        StockMinimo >= 0
        AND PuntoReposicion >= StockMinimo
        AND StockObjetivo >= PuntoReposicion
    )
) ON FG_DATA;
GO



