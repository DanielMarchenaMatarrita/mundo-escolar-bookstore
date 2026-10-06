USE MundoEscolar;
GO

PRINT '=== VALIDATION: Commercial Identity Model ===';
GO

/* 1. Expected table count */
IF (
    SELECT COUNT(*)
    FROM sys.tables
    WHERE name IN (
        N'Tercero',
        N'Persona',
        N'Organizacion',
        N'Cliente',
        N'Proveedor',
        N'ContactoTercero',
        N'DireccionTercero'
    )
) <> 7
BEGIN
    THROW 52101, N'Validation failed: expected 7 commercial identity tables.', 1;
END;
GO

/* 2. Primary clustered indexes must live in FG_DATA */
IF EXISTS
(
    SELECT 1
    FROM sys.tables AS t
    JOIN sys.indexes AS i
        ON t.object_id = i.object_id
    JOIN sys.data_spaces AS ds
        ON i.data_space_id = ds.data_space_id
    WHERE t.name IN (
        N'Tercero',
        N'Persona',
        N'Organizacion',
        N'Cliente',
        N'Proveedor',
        N'ContactoTercero',
        N'DireccionTercero'
    )
      AND i.is_primary_key = 1
      AND ds.name <> N'FG_DATA'
)
BEGIN
    THROW 52102, N'Validation failed: one or more primary keys are not stored in FG_DATA.', 1;
END;
GO

/* 3. Required unique nonclustered indexes must live in FG_INDEX */
IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes AS i
    JOIN sys.data_spaces AS ds
        ON i.data_space_id = ds.data_space_id
    WHERE i.object_id = OBJECT_ID(N'dbo.Tercero')
      AND i.name = N'UQ_Tercero_Identificacion'
      AND i.is_unique = 1
      AND i.type_desc = N'NONCLUSTERED'
      AND ds.name = N'FG_INDEX'
)
BEGIN
    THROW 52103, N'Validation failed: UQ_Tercero_Identificacion is missing or not stored in FG_INDEX.', 1;
END;
GO

IF NOT EXISTS
(
    SELECT 1
    FROM sys.indexes AS i
    JOIN sys.data_spaces AS ds
        ON i.data_space_id = ds.data_space_id
    WHERE i.object_id = OBJECT_ID(N'dbo.ContactoTercero')
      AND i.name = N'UQ_ContactoTercero_TipoValor'
      AND i.is_unique = 1
      AND i.type_desc = N'NONCLUSTERED'
      AND ds.name = N'FG_INDEX'
)
BEGIN
    THROW 52104, N'Validation failed: UQ_ContactoTercero_TipoValor is missing or not stored in FG_INDEX.', 1;
END;
GO

/* 4. Required CHECK constraints */
IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_Tercero_TipoIdentificacion_NoVacio'
)
    THROW 52105, N'Validation failed: CK_Tercero_TipoIdentificacion_NoVacio is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_Tercero_NumeroIdentificacion_NoVacio'
)
    THROW 52106, N'Validation failed: CK_Tercero_NumeroIdentificacion_NoVacio is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_Tercero_Estado'
)
    THROW 52107, N'Validation failed: CK_Tercero_Estado is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_Persona_Nombre_NoVacio'
)
    THROW 52108, N'Validation failed: CK_Persona_Nombre_NoVacio is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_Persona_PrimerApellido_NoVacio'
)
    THROW 52109, N'Validation failed: CK_Persona_PrimerApellido_NoVacio is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_Organizacion_RazonSocial_NoVacia'
)
    THROW 52110, N'Validation failed: CK_Organizacion_RazonSocial_NoVacia is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_Cliente_Credito'
)
    THROW 52111, N'Validation failed: CK_Cliente_Credito is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_Proveedor_CodigoProveedor_NoVacio'
)
    THROW 52112, N'Validation failed: CK_Proveedor_CodigoProveedor_NoVacio is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_Proveedor_EstadoComercial'
)
    THROW 52113, N'Validation failed: CK_Proveedor_EstadoComercial is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_ContactoTercero_TipoContacto_NoVacio'
)
    THROW 52114, N'Validation failed: CK_ContactoTercero_TipoContacto_NoVacio is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_ContactoTercero_Valor_NoVacio'
)
    THROW 52115, N'Validation failed: CK_ContactoTercero_Valor_NoVacio is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_DireccionTercero_Pais_NoVacio'
)
    THROW 52116, N'Validation failed: CK_DireccionTercero_Pais_NoVacio is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_DireccionTercero_Provincia_NoVacia'
)
    THROW 52117, N'Validation failed: CK_DireccionTercero_Provincia_NoVacia is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_DireccionTercero_Canton_NoVacio'
)
    THROW 52118, N'Validation failed: CK_DireccionTercero_Canton_NoVacio is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints
    WHERE name = N'CK_DireccionTercero_Detalle_NoVacio'
)
    THROW 52119, N'Validation failed: CK_DireccionTercero_Detalle_NoVacio is missing.', 1;
GO

/* 5. Required defaults */
IF NOT EXISTS (
    SELECT 1
    FROM sys.default_constraints
    WHERE name = N'DF_ContactoTercero_Principal'
)
    THROW 52120, N'Validation failed: DF_ContactoTercero_Principal is missing.', 1;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.default_constraints
    WHERE name = N'DF_DireccionTercero_Principal'
)
    THROW 52121, N'Validation failed: DF_DireccionTercero_Principal is missing.', 1;
GO

/* 6. Foreign keys must not exist yet in this checkpoint */
IF EXISTS
(
    SELECT 1
    FROM sys.foreign_keys AS fk
    WHERE fk.parent_object_id IN (
        OBJECT_ID(N'dbo.Persona'),
        OBJECT_ID(N'dbo.Organizacion'),
        OBJECT_ID(N'dbo.Cliente'),
        OBJECT_ID(N'dbo.Proveedor'),
        OBJECT_ID(N'dbo.ContactoTercero'),
        OBJECT_ID(N'dbo.DireccionTercero')
    )
)
BEGIN
    THROW 52122, N'Validation failed: foreign keys were added before the referential-integrity phase.', 1;
END;
GO

PRINT 'PASS: Commercial Identity Model is valid.';
GO