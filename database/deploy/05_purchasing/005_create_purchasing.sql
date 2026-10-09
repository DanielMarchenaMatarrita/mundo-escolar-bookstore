USE MundoEscolar;
GO

-- ============================================================================
-- D. COMPRAS
-- ============================================================================

CREATE TABLE dbo.OrdenCompra (
    IdOrdenCompra INT IDENTITY(1,1) NOT NULL,
    IdProveedor INT NOT NULL,
    IdUsuario INT NOT NULL,
    FechaOrden DATETIME2(0) NOT NULL,
    Estado VARCHAR(30) NOT NULL,
    Observaciones NVARCHAR(500) NULL,
    CONSTRAINT PK_OrdenCompra PRIMARY KEY CLUSTERED (IdOrdenCompra),
    CONSTRAINT CK_OrdenCompra_Estado CHECK (Estado IN ('BORRADOR','EMITIDA','PARCIALMENTE_RECIBIDA','RECIBIDA','CANCELADA'))
) ON FG_DATA;
GO

CREATE TABLE dbo.LineaOrdenCompra (
    IdLineaOrden INT IDENTITY(1,1) NOT NULL,
    IdOrdenCompra INT NOT NULL,
    NumeroLinea INT NOT NULL,
    IdItemComercial INT NOT NULL,
    CantidadSolicitada INT NOT NULL,
    CostoUnitarioPactado DECIMAL(19,4) NOT NULL,
    CONSTRAINT PK_LineaOrdenCompra PRIMARY KEY CLUSTERED (IdLineaOrden),
    CONSTRAINT UQ_LineaOrdenCompra_NumeroLinea UNIQUE NONCLUSTERED (IdOrdenCompra, NumeroLinea) ON FG_INDEX,
    CONSTRAINT CK_LineaOrdenCompra_NumeroLinea CHECK (NumeroLinea > 0),
    CONSTRAINT CK_LineaOrdenCompra_Cantidad CHECK (CantidadSolicitada > 0),
    CONSTRAINT CK_LineaOrdenCompra_Costo CHECK (CostoUnitarioPactado >= 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.RecepcionCompra (
    IdRecepcion INT IDENTITY(1,1) NOT NULL,
    IdOrdenCompra INT NOT NULL,
    IdUbicacionDestino INT NOT NULL,
    IdUsuario INT NOT NULL,
    FechaRecepcion DATETIME2(0) NOT NULL,
    DocumentoProveedor NVARCHAR(100) NULL,
    IdMovimientoInventario INT NULL,
    CONSTRAINT PK_RecepcionCompra PRIMARY KEY CLUSTERED (IdRecepcion)
) ON FG_DATA;
GO

CREATE TABLE dbo.LineaRecepcion (
    IdRecepcion INT NOT NULL,
    IdLineaOrden INT NOT NULL,
    CantidadRecibida INT NOT NULL,
    CantidadRechazada INT NOT NULL,
    CONSTRAINT PK_LineaRecepcion PRIMARY KEY CLUSTERED (IdRecepcion, IdLineaOrden),
    CONSTRAINT CK_LineaRecepcion_Cantidades CHECK (
        CantidadRecibida >= 0
        AND CantidadRechazada >= 0
        AND CantidadRecibida + CantidadRechazada > 0
    )
) ON FG_DATA;
GO



