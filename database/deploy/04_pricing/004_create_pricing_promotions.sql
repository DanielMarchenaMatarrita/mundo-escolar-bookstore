USE MundoEscolar;
GO

-- ============================================================================
-- C. PRICING Y PROMOCIONES
-- ============================================================================

CREATE TABLE dbo.ListaPrecio (
    IdListaPrecio INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    Descripcion NVARCHAR(500) NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_ListaPrecio PRIMARY KEY CLUSTERED (IdListaPrecio),
    CONSTRAINT UQ_ListaPrecio_Nombre UNIQUE NONCLUSTERED (Nombre) ON FG_INDEX,
    CONSTRAINT CK_ListaPrecio_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_ListaPrecio_Estado CHECK (Estado IN ('ACTIVO','INACTIVO'))
) ON FG_DATA;
GO

CREATE TABLE dbo.Precio (
    IdPrecio INT IDENTITY(1,1) NOT NULL,
    IdListaPrecio INT NOT NULL,
    IdConceptoComercial INT NOT NULL,
    VigenteDesde DATETIME2(0) NOT NULL,
    VigenteHasta DATETIME2(0) NULL,
    CONSTRAINT PK_Precio PRIMARY KEY CLUSTERED (IdPrecio),
    CONSTRAINT UQ_Precio_ListaConceptoDesde UNIQUE NONCLUSTERED (IdListaPrecio, IdConceptoComercial, VigenteDesde) ON FG_INDEX,
    CONSTRAINT CK_Precio_Vigencia CHECK (VigenteHasta IS NULL OR VigenteHasta >= VigenteDesde)
) ON FG_DATA;
GO

CREATE TABLE dbo.EscalaPrecio (
    IdPrecio INT NOT NULL,
    CantidadMinima INT NOT NULL,
    CantidadMaxima INT NULL,
    PrecioUnitario DECIMAL(19,4) NOT NULL,
    CONSTRAINT PK_EscalaPrecio PRIMARY KEY CLUSTERED (IdPrecio, CantidadMinima),
    CONSTRAINT CK_EscalaPrecio_CantidadMinima CHECK (CantidadMinima > 0),
    CONSTRAINT CK_EscalaPrecio_CantidadMaxima CHECK (CantidadMaxima IS NULL OR CantidadMaxima >= CantidadMinima),
    CONSTRAINT CK_EscalaPrecio_PrecioUnitario CHECK (PrecioUnitario >= 0)
) ON FG_DATA;
GO

CREATE TABLE dbo.TemporadaComercial (
    IdTemporada INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE NOT NULL,
    CONSTRAINT PK_TemporadaComercial PRIMARY KEY CLUSTERED (IdTemporada),
    CONSTRAINT UQ_TemporadaComercial_NombreInicio UNIQUE NONCLUSTERED (Nombre, FechaInicio) ON FG_INDEX,
    CONSTRAINT CK_TemporadaComercial_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_TemporadaComercial_Fechas CHECK (FechaFin >= FechaInicio)
) ON FG_DATA;
GO

CREATE TABLE dbo.CampanaPromocional (
    IdCampana INT IDENTITY(1,1) NOT NULL,
    IdTemporada INT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    FechaInicio DATETIME2(0) NOT NULL,
    FechaFin DATETIME2(0) NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_CampanaPromocional PRIMARY KEY CLUSTERED (IdCampana),
    CONSTRAINT CK_CampanaPromocional_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_CampanaPromocional_Fechas CHECK (FechaFin >= FechaInicio),
    CONSTRAINT CK_CampanaPromocional_Estado CHECK (Estado IN ('BORRADOR','HABILITADA','CERRADA','CANCELADA'))
) ON FG_DATA;
GO

CREATE TABLE dbo.Promocion (
    IdPromocion INT IDENTITY(1,1) NOT NULL,
    IdCampana INT NULL,
    Nombre NVARCHAR(150) NOT NULL,
    Descripcion NVARCHAR(500) NULL,
    TipoPromocion VARCHAR(30) NOT NULL,
    CantidadMinima INT NULL,
    PorcentajeDescuento DECIMAL(9,6) NULL,
    MontoDescuento DECIMAL(19,4) NULL,
    PrecioPromocional DECIMAL(19,4) NULL,
    CantidadBonificada INT NULL,
    FechaInicio DATETIME2(0) NOT NULL,
    FechaFin DATETIME2(0) NOT NULL,
    Combinable BIT NOT NULL,
    Estado VARCHAR(20) NOT NULL,
    CONSTRAINT PK_Promocion PRIMARY KEY CLUSTERED (IdPromocion),
    CONSTRAINT CK_Promocion_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_Promocion_Tipo CHECK (TipoPromocion IN ('PORCENTAJE','MONTO_FIJO','PRECIO_PROMOCIONAL','BONIFICACION_CANTIDAD')),
    CONSTRAINT CK_Promocion_CantidadMinima CHECK (CantidadMinima IS NULL OR CantidadMinima > 0),
    CONSTRAINT CK_Promocion_Porcentaje CHECK (PorcentajeDescuento IS NULL OR (PorcentajeDescuento > 0 AND PorcentajeDescuento <= 1)),
    CONSTRAINT CK_Promocion_MontoDescuento CHECK (MontoDescuento IS NULL OR MontoDescuento > 0),
    CONSTRAINT CK_Promocion_PrecioPromocional CHECK (PrecioPromocional IS NULL OR PrecioPromocional >= 0),
    CONSTRAINT CK_Promocion_CantidadBonificada CHECK (CantidadBonificada IS NULL OR CantidadBonificada > 0),
    CONSTRAINT CK_Promocion_Fechas CHECK (FechaFin >= FechaInicio),
    CONSTRAINT CK_Promocion_Estado CHECK (Estado IN ('BORRADOR','HABILITADA','CANCELADA')),
    CONSTRAINT CK_Promocion_BeneficioXOR CHECK (
        (TipoPromocion = 'PORCENTAJE'
            AND PorcentajeDescuento IS NOT NULL
            AND MontoDescuento IS NULL
            AND PrecioPromocional IS NULL
            AND CantidadBonificada IS NULL)
        OR
        (TipoPromocion = 'MONTO_FIJO'
            AND PorcentajeDescuento IS NULL
            AND MontoDescuento IS NOT NULL
            AND PrecioPromocional IS NULL
            AND CantidadBonificada IS NULL)
        OR
        (TipoPromocion = 'PRECIO_PROMOCIONAL'
            AND PorcentajeDescuento IS NULL
            AND MontoDescuento IS NULL
            AND PrecioPromocional IS NOT NULL
            AND CantidadBonificada IS NULL)
        OR
        (TipoPromocion = 'BONIFICACION_CANTIDAD'
            AND PorcentajeDescuento IS NULL
            AND MontoDescuento IS NULL
            AND PrecioPromocional IS NULL
            AND CantidadBonificada IS NOT NULL)
    )
) ON FG_DATA;
GO

CREATE TABLE dbo.PromocionConcepto (
    IdPromocion INT NOT NULL,
    IdConceptoComercial INT NOT NULL,
    CONSTRAINT PK_PromocionConcepto PRIMARY KEY CLUSTERED (IdPromocion, IdConceptoComercial)
) ON FG_DATA;
GO

CREATE TABLE dbo.PromocionCategoria (
    IdPromocion INT NOT NULL,
    IdCategoria INT NOT NULL,
    CONSTRAINT PK_PromocionCategoria PRIMARY KEY CLUSTERED (IdPromocion, IdCategoria)
) ON FG_DATA;
GO



