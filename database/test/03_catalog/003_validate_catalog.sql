USE MundoEscolar;
GO

PRINT '=== VALIDATION: Catalog ===';
GO

DECLARE @Missing NVARCHAR(2048);

DECLARE @ExpectedTables TABLE (Name SYSNAME PRIMARY KEY);
INSERT INTO @ExpectedTables (Name) VALUES
    (N'CategoriaProducto'),
    (N'Marca'),
    (N'Producto'),
    (N'Editorial'),
    (N'Libro'),
    (N'Autor'),
    (N'LibroAutor'),
    (N'Presentacion'),
    (N'ConceptoComercial'),
    (N'ItemComercial'),
    (N'Servicio'),
    (N'ProveedorItemComercial');

SELECT @Missing = STRING_AGG(CONVERT(NVARCHAR(MAX), e.Name), N', ')
FROM @ExpectedTables AS e
WHERE OBJECT_ID(N'dbo.' + e.Name, N'U') IS NULL;

IF @Missing IS NOT NULL
BEGIN
    DECLARE @MsgTables NVARCHAR(2048) =
        N'Validation failed: missing table(s): ' + @Missing;
    THROW 52201, @MsgTables, 1;
END;

/* Every domain table must have its clustered primary key in FG_DATA. */
SELECT @Missing = STRING_AGG(CONVERT(NVARCHAR(MAX), e.Name), N', ')
FROM @ExpectedTables AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM sys.tables AS t
    JOIN sys.indexes AS i
        ON i.object_id = t.object_id
       AND i.is_primary_key = 1
       AND i.type_desc = N'CLUSTERED'
    JOIN sys.data_spaces AS ds
        ON ds.data_space_id = i.data_space_id
    WHERE t.name = e.Name
      AND SCHEMA_NAME(t.schema_id) = N'dbo'
      AND ds.name = N'FG_DATA'
);

IF @Missing IS NOT NULL
BEGIN
    DECLARE @MsgPK NVARCHAR(2048) =
        N'Validation failed: table(s) without clustered PK in FG_DATA: ' + @Missing;
    THROW 52202, @MsgPK, 1;
END;

/* Unique constraints defined by this checkpoint must live in FG_INDEX. */
DECLARE @ExpectedUQ TABLE (Name SYSNAME PRIMARY KEY);
INSERT INTO @ExpectedUQ (Name) VALUES
    (N'UQ_CategoriaProducto_PadreNombre'),
    (N'UQ_Marca_Nombre'),
    (N'UQ_Editorial_Nombre'),
    (N'UQ_LibroAutor_Orden'),
    (N'UQ_ItemComercial_ProductoPresentacion'),
    (N'UQ_ItemComercial_SKU'),
    (N'UQ_Servicio_Nombre');

SELECT @Missing = STRING_AGG(CONVERT(NVARCHAR(MAX), e.Name), N', ')
FROM @ExpectedUQ AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM sys.indexes AS i
    JOIN sys.data_spaces AS ds
        ON ds.data_space_id = i.data_space_id
    WHERE i.name = e.Name
      AND i.is_unique = 1
      AND i.type_desc = N'NONCLUSTERED'
      AND ds.name = N'FG_INDEX'
);

IF @Missing IS NOT NULL
BEGIN
    DECLARE @MsgUQ NVARCHAR(2048) =
        N'Validation failed: missing/incorrect unique constraint index(es): ' + @Missing;
    THROW 52203, @MsgUQ, 1;
END;

/* Required CHECK constraints. */
DECLARE @ExpectedChecks TABLE (Name SYSNAME PRIMARY KEY);
INSERT INTO @ExpectedChecks (Name) VALUES
    (N'CK_CategoriaProducto_NoAutorreferencia'),
    (N'CK_CategoriaProducto_Nombre_NoVacio'),
    (N'CK_Marca_Nombre_NoVacio'),
    (N'CK_Marca_Estado'),
    (N'CK_Producto_Nombre_NoVacio'),
    (N'CK_Producto_Estado'),
    (N'CK_Editorial_Nombre_NoVacio'),
    (N'CK_Libro_AnioPublicacion'),
    (N'CK_Libro_ISBN_NoVacio'),
    (N'CK_Autor_Nombre_NoVacio'),
    (N'CK_LibroAutor_Orden'),
    (N'CK_Presentacion_Nombre_NoVacio'),
    (N'CK_Presentacion_CantidadBase'),
    (N'CK_Presentacion_UnidadBase_NoVacia'),
    (N'CK_Presentacion_Estado'),
    (N'CK_ConceptoComercial_Tipo'),
    (N'CK_ConceptoComercial_Estado'),
    (N'CK_ItemComercial_SKU_NoVacio'),
    (N'CK_ItemComercial_CodigoBarras_NoVacio'),
    (N'CK_Servicio_Nombre_NoVacio'),
    (N'CK_Servicio_Estado');

SELECT @Missing = STRING_AGG(CONVERT(NVARCHAR(MAX), e.Name), N', ')
FROM @ExpectedChecks AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM sys.check_constraints AS c
    WHERE c.name = e.Name
      AND c.is_disabled = 0
);

IF @Missing IS NOT NULL
BEGIN
    DECLARE @MsgChecks NVARCHAR(2048) =
        N'Validation failed: missing/disabled CHECK constraint(s): ' + @Missing;
    THROW 52204, @MsgChecks, 1;
END;

/* Required DEFAULT constraints. */
DECLARE @ExpectedDefaults TABLE (Name SYSNAME PRIMARY KEY);
INSERT INTO @ExpectedDefaults (Name) VALUES
    (N'DF_ProveedorItemComercial_EsPreferido');

SELECT @Missing = STRING_AGG(CONVERT(NVARCHAR(MAX), e.Name), N', ')
FROM @ExpectedDefaults AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM sys.default_constraints AS d
    WHERE d.name = e.Name
);

IF @Missing IS NOT NULL
BEGIN
    DECLARE @MsgDefaults NVARCHAR(2048) =
        N'Validation failed: missing DEFAULT constraint(s): ' + @Missing;
    THROW 52205, @MsgDefaults, 1;
END;

PRINT 'PASS: Catalog is valid.';
GO
