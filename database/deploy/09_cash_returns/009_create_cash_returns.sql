USE MundoEscolar;
GO

-- ============================================================================
-- H. CAJA Y DEVOLUCIONES
-- ============================================================================

CREATE TABLE dbo.Caja (
    IdCaja INT IDENTITY(1,1) NOT NULL,
    IdSucursal INT NOT NULL,
    Codigo VARCHAR(50) NOT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Caja PRIMARY KEY CLUSTERED (IdCaja),
    CONSTRAINT UQ_Caja_Codigo UNIQUE NONCLUSTERED (Codigo) ON FG_INDEX,
    CONSTRAINT CK_Caja_Codigo_NoVacio CHECK (LEN(LTRIM(RTRIM(Codigo))) > 0),
    CONSTRAINT CK_Caja_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_Caja_Estado CHECK (Estado IN ('ACTIVO','INACTIVO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.SesionCaja (
    IdSesionCaja INT IDENTITY(1,1) NOT NULL,
    IdCaja INT NOT NULL,
    IdUsuarioApertura INT NOT NULL,
    FechaApertura DATETIME2(0) NOT NULL,
    MontoApertura DECIMAL(19,4) NOT NULL,
    IdUsuarioCierre INT NULL,
    FechaCierre DATETIME2(0) NULL,
    MontoDeclaradoCierre DECIMAL(19,4) NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_SesionCaja PRIMARY KEY CLUSTERED (IdSesionCaja),
    CONSTRAINT CK_SesionCaja_MontoApertura CHECK (MontoApertura >= 0),
    CONSTRAINT CK_SesionCaja_MontoCierre CHECK (MontoDeclaradoCierre IS NULL OR MontoDeclaradoCierre >= 0),
    CONSTRAINT CK_SesionCaja_Estado CHECK (Estado IN ('ABIERTA','CERRADA')),
    CONSTRAINT CK_SesionCaja_Cierre CHECK (
        (Estado = 'ABIERTA'
            AND IdUsuarioCierre IS NULL
            AND FechaCierre IS NULL
            AND MontoDeclaradoCierre IS NULL)
        OR
        (Estado = 'CERRADA'
            AND IdUsuarioCierre IS NOT NULL
            AND FechaCierre IS NOT NULL
            AND FechaCierre >= FechaApertura
            AND MontoDeclaradoCierre IS NOT NULL)
    )
) ON FG_DATA;
GO

CREATE TABLE dbo.MovimientoCaja (
    IdMovimientoCaja INT IDENTITY(1,1) NOT NULL,
    IdSesionCaja INT NOT NULL,
    IdPago INT NULL,
    IdReembolso INT NULL,
    TipoMovimiento VARCHAR(30) NOT NULL,
    Fecha DATETIME2(0) NOT NULL,
    Monto DECIMAL(19,4) NOT NULL,
    Concepto NVARCHAR(500) NULL,
    CONSTRAINT PK_MovimientoCaja PRIMARY KEY CLUSTERED (IdMovimientoCaja),
    CONSTRAINT CK_MovimientoCaja_Tipo CHECK (
        TipoMovimiento IN ('PAGO','REEMBOLSO','INGRESO_MANUAL','RETIRO','AJUSTE')
    ),
    CONSTRAINT CK_MovimientoCaja_Monto CHECK (Monto > 0),
    CONSTRAINT CK_MovimientoCaja_Origen CHECK (
        (TipoMovimiento = 'PAGO' AND IdPago IS NOT NULL AND IdReembolso IS NULL)
        OR
        (TipoMovimiento = 'REEMBOLSO' AND IdPago IS NULL AND IdReembolso IS NOT NULL)
        OR
        (TipoMovimiento IN ('INGRESO_MANUAL','RETIRO','AJUSTE') AND IdPago IS NULL AND IdReembolso IS NULL)
    )
) ON FG_DATA;
GO

CREATE TABLE dbo.DevolucionVenta (
    IdDevolucion INT IDENTITY(1,1) NOT NULL,
    IdVenta INT NOT NULL,
    IdUsuario INT NOT NULL,
    Fecha DATETIME2(0) NOT NULL,
    Motivo NVARCHAR(500) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    IdMovimientoInventario INT NULL,
    CONSTRAINT PK_DevolucionVenta PRIMARY KEY CLUSTERED (IdDevolucion),
    CONSTRAINT CK_DevolucionVenta_Motivo_NoVacio CHECK (LEN(LTRIM(RTRIM(Motivo))) > 0),
    CONSTRAINT CK_DevolucionVenta_Estado CHECK (Estado IN ('SOLICITADA','APROBADA','PROCESADA','RECHAZADA'))
) ON FG_DATA;
GO

CREATE TABLE dbo.LineaDevolucion (
    IdDevolucion INT NOT NULL,
    IdLineaVenta INT NOT NULL,
    CantidadDevuelta INT NOT NULL,
    CondicionProducto VARCHAR(30) NULL,
    ReintegrableInventario BIT NOT NULL,
    CONSTRAINT PK_LineaDevolucion PRIMARY KEY CLUSTERED (IdDevolucion, IdLineaVenta),
    CONSTRAINT CK_LineaDevolucion_Cantidad CHECK (CantidadDevuelta > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.NotaCredito (
    IdNotaCredito INT IDENTITY(1,1) NOT NULL,
    IdDevolucion INT NOT NULL,
    IdCuentaCobrar INT NOT NULL,
    NumeroNota VARCHAR(50) NOT NULL,
    FechaEmision DATETIME2(0) NOT NULL,
    MontoCredito DECIMAL(19,4) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_NotaCredito PRIMARY KEY CLUSTERED (IdNotaCredito),
    CONSTRAINT UQ_NotaCredito_IdDevolucion UNIQUE NONCLUSTERED (IdDevolucion) ON FG_INDEX,
    CONSTRAINT UQ_NotaCredito_NumeroNota UNIQUE NONCLUSTERED (NumeroNota) ON FG_INDEX,
    CONSTRAINT CK_NotaCredito_Numero_NoVacio CHECK (LEN(LTRIM(RTRIM(NumeroNota))) > 0),
    CONSTRAINT CK_NotaCredito_Monto CHECK (MontoCredito > 0),
    CONSTRAINT CK_NotaCredito_Estado CHECK (Estado IN ('EMITIDA','ANULADA'))
) ON FG_DATA;
GO

CREATE TABLE dbo.Reembolso (
    IdReembolso INT IDENTITY(1,1) NOT NULL,
    IdNotaCredito INT NOT NULL,
    IdMetodoPago INT NOT NULL,
    IdUsuario INT NOT NULL,
    Fecha DATETIME2(0) NOT NULL,
    Monto DECIMAL(19,4) NOT NULL,
    CONSTRAINT PK_Reembolso PRIMARY KEY CLUSTERED (IdReembolso),
    CONSTRAINT CK_Reembolso_Monto CHECK (Monto > 0)
) ON FG_DATA;
GO



