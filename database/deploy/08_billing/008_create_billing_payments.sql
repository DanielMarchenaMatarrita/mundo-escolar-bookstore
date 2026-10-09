USE MundoEscolar;
GO

-- ============================================================================
-- G. FACTURACIÓN Y PAGOS
-- ============================================================================

CREATE TABLE dbo.Factura (
    IdFactura INT IDENTITY(1,1) NOT NULL,
    IdVenta INT NOT NULL,
    NumeroFactura VARCHAR(50) NOT NULL,
    FechaEmision DATETIME2(0) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Factura PRIMARY KEY CLUSTERED (IdFactura),
    CONSTRAINT UQ_Factura_IdVenta UNIQUE NONCLUSTERED (IdVenta) ON FG_INDEX,
    CONSTRAINT UQ_Factura_NumeroFactura UNIQUE NONCLUSTERED (NumeroFactura) ON FG_INDEX,
    CONSTRAINT CK_Factura_Numero_NoVacio CHECK (LEN(LTRIM(RTRIM(NumeroFactura))) > 0),
    CONSTRAINT CK_Factura_Estado CHECK (Estado IN ('EMITIDA','ANULADA'))
) ON FG_DATA;
GO

CREATE TABLE dbo.CuentaPorCobrar (
    IdCuentaCobrar INT IDENTITY(1,1) NOT NULL,
    IdFactura INT NOT NULL,
    FechaVencimiento DATE NOT NULL,
    EstadoOperacional VARCHAR(20) NOT NULL,
    CONSTRAINT PK_CuentaPorCobrar PRIMARY KEY CLUSTERED (IdCuentaCobrar),
    CONSTRAINT UQ_CuentaPorCobrar_IdFactura UNIQUE NONCLUSTERED (IdFactura) ON FG_INDEX,
    CONSTRAINT CK_CuentaPorCobrar_Estado CHECK (EstadoOperacional IN ('PENDIENTE','PARCIAL','SALDADA','VENCIDA'))
) ON FG_DATA;
GO

CREATE TABLE dbo.MetodoPago (
    IdMetodoPago INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(100) NOT NULL,
    RequiereReferencia BIT NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_MetodoPago PRIMARY KEY CLUSTERED (IdMetodoPago),
    CONSTRAINT UQ_MetodoPago_Nombre UNIQUE NONCLUSTERED (Nombre) ON FG_INDEX,
    CONSTRAINT CK_MetodoPago_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_MetodoPago_Estado CHECK (Estado IN ('ACTIVO','INACTIVO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.Pago (
    IdPago INT IDENTITY(1,1) NOT NULL,
    IdMetodoPago INT NOT NULL,
    IdUsuario INT NOT NULL,
    FechaPago DATETIME2(0) NOT NULL,
    Monto DECIMAL(19,4) NOT NULL,
    Referencia NVARCHAR(100) NULL,
    CONSTRAINT PK_Pago PRIMARY KEY CLUSTERED (IdPago),
    CONSTRAINT CK_Pago_Monto CHECK (Monto > 0),
    CONSTRAINT CK_Pago_Referencia_NoVacia CHECK (Referencia IS NULL OR LEN(LTRIM(RTRIM(Referencia))) > 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.AplicacionPago (
    IdPago INT NOT NULL,
    IdCuentaCobrar INT NOT NULL,
    MontoAplicado DECIMAL(19,4) NOT NULL,
    CONSTRAINT PK_AplicacionPago PRIMARY KEY CLUSTERED (IdPago, IdCuentaCobrar),
    CONSTRAINT CK_AplicacionPago_Monto CHECK (MontoAplicado > 0)
) ON FG_DATA;
GO



