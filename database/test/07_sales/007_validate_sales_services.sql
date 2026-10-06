USE MundoEscolar;
GO

PRINT '=== VALIDATION: Sales and Services ===';
GO

DECLARE @Missing NVARCHAR(2048);

DECLARE @ExpectedTables TABLE (Name SYSNAME PRIMARY KEY);
INSERT INTO @ExpectedTables (Name) VALUES
    (N'Venta'),
    (N'LineaVenta'),
    (N'PromocionAplicada'),
    (N'TrabajoServicio');

SELECT @Missing = STRING_AGG(CONVERT(NVARCHAR(MAX), e.Name), N', ')
FROM @ExpectedTables AS e
WHERE OBJECT_ID(N'dbo.' + e.Name, N'U') IS NULL;

IF @Missing IS NOT NULL
BEGIN
    DECLARE @MsgTables NVARCHAR(2048) =
        N'Validation failed: missing table(s): ' + @Missing;
    THROW 52241, @MsgTables, 1;
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
    THROW 52242, @MsgPK, 1;
END;

/* Unique constraints defined by this checkpoint must live in FG_INDEX. */
DECLARE @ExpectedUQ TABLE (Name SYSNAME PRIMARY KEY);
INSERT INTO @ExpectedUQ (Name) VALUES
    (N'UQ_LineaVenta_NumeroLinea');

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
    THROW 52243, @MsgUQ, 1;
END;

/* Required CHECK constraints. */
DECLARE @ExpectedChecks TABLE (Name SYSNAME PRIMARY KEY);
INSERT INTO @ExpectedChecks (Name) VALUES
    (N'CK_Venta_Estado'),
    (N'CK_LineaVenta_NumeroLinea'),
    (N'CK_LineaVenta_Cantidad'),
    (N'CK_LineaVenta_Precio'),
    (N'CK_LineaVenta_Descuento'),
    (N'CK_LineaVenta_TasaImpuesto'),
    (N'CK_PromocionAplicada_Monto'),
    (N'CK_TrabajoServicio_Estado'),
    (N'CK_TrabajoServicio_Fechas');

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
    THROW 52244, @MsgChecks, 1;
END;

PRINT 'PASS: Sales and Services is valid.';
GO
