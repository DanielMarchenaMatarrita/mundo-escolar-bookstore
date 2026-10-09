USE MundoEscolar;
GO

-- ============================================================================
-- F. VENTAS Y SERVICIOS
-- ============================================================================

CREATE TABLE dbo.Venta (
    IdVenta INT IDENTITY(1,1) NOT NULL,
    IdCliente INT NULL,
    IdUsuario INT NOT NULL,
    IdSucursal INT NOT NULL,
    IdSesionCaja INT NULL,
    Fecha DATETIME2(0) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    IdMovimientoInventario INT NULL,
    CONSTRAINT PK_Venta PRIMARY KEY CLUSTERED (IdVenta),
    CONSTRAINT CK_Venta_Estado CHECK (Estado IN ('BORRADOR','CONFIRMADA','ANULADA'))
) ON FG_DATA;
GO

CREATE TABLE dbo.LineaVenta (
    IdLineaVenta INT IDENTITY(1,1) NOT NULL,
    IdVenta INT NOT NULL,
    NumeroLinea INT NOT NULL,
    IdConceptoComercial INT NOT NULL,
    Cantidad INT NOT NULL,
    PrecioUnitarioAplicado DECIMAL(19,4) NOT NULL,
    DescuentoAplicado DECIMAL(19,4) NOT NULL,
    TasaImpuestoAplicada DECIMAL(9,6) NOT NULL,
    CONSTRAINT PK_LineaVenta PRIMARY KEY CLUSTERED (IdLineaVenta),
    CONSTRAINT UQ_LineaVenta_NumeroLinea UNIQUE NONCLUSTERED (IdVenta, NumeroLinea) ON FG_INDEX,
    CONSTRAINT CK_LineaVenta_NumeroLinea CHECK (NumeroLinea > 0),
    CONSTRAINT CK_LineaVenta_Cantidad CHECK (Cantidad > 0),
    CONSTRAINT CK_LineaVenta_Precio CHECK (PrecioUnitarioAplicado >= 0),
    CONSTRAINT CK_LineaVenta_Descuento CHECK (
        DescuentoAplicado >= 0
        AND DescuentoAplicado <= (Cantidad * PrecioUnitarioAplicado)
    ),
    CONSTRAINT CK_LineaVenta_TasaImpuesto CHECK (TasaImpuestoAplicada >= 0 AND TasaImpuestoAplicada <= 1)
) ON FG_DATA;
GO

CREATE TABLE dbo.PromocionAplicada (
    IdLineaVenta INT NOT NULL,
    IdPromocion INT NOT NULL,
    MontoBeneficio DECIMAL(19,4) NOT NULL,
    CONSTRAINT PK_PromocionAplicada PRIMARY KEY CLUSTERED (IdLineaVenta, IdPromocion),
    CONSTRAINT CK_PromocionAplicada_Monto CHECK (MontoBeneficio >= 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.TrabajoServicio (
    IdLineaVenta INT NOT NULL,
    EstadoTrabajo VARCHAR(20) NOT NULL,
    FechaSolicitud DATETIME2(0) NOT NULL,
    FechaTerminacion DATETIME2(0) NULL,
    FechaEntrega DATETIME2(0) NULL,
    Especificacion NVARCHAR(500) NULL,
    CONSTRAINT PK_TrabajoServicio PRIMARY KEY CLUSTERED (IdLineaVenta),
    CONSTRAINT CK_TrabajoServicio_Estado CHECK (
        EstadoTrabajo IN ('PENDIENTE','EN_PROCESO','TERMINADO','ENTREGADO','CANCELADO')
    ),
    CONSTRAINT CK_TrabajoServicio_Fechas CHECK (
        (FechaTerminacion IS NULL OR FechaTerminacion >= FechaSolicitud)
        AND
        (FechaEntrega IS NULL OR (FechaTerminacion IS NOT NULL AND FechaEntrega >= FechaTerminacion))
    )
) ON FG_DATA;
GO



