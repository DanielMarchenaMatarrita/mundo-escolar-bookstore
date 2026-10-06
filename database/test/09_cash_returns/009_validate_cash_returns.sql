USE MundoEscolar;
GO

PRINT '=== VALIDATION: Cash and Returns ===';
GO

DECLARE @Missing NVARCHAR(2048);

DECLARE @ExpectedTables TABLE (Name SYSNAME PRIMARY KEY);
INSERT INTO @ExpectedTables (Name) VALUES
    (N'Caja'),
    (N'SesionCaja'),
    (N'MovimientoCaja'),
    (N'DevolucionVenta'),
    (N'LineaDevolucion'),
    (N'NotaCredito'),
    (N'Reembolso');

SELECT @Missing = STRING_AGG(CONVERT(NVARCHAR(MAX), e.Name), N', ')
FROM @ExpectedTables AS e
WHERE OBJECT_ID(N'dbo.' + e.Name, N'U') IS NULL;

IF @Missing IS NOT NULL
BEGIN
    DECLARE @MsgTables NVARCHAR(2048) =
        N'Validation failed: missing table(s): ' + @Missing;
    THROW 52261, @MsgTables, 1;
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
    THROW 52262, @MsgPK, 1;
END;

/* Unique constraints defined by this checkpoint must live in FG_INDEX. */
DECLARE @ExpectedUQ TABLE (Name SYSNAME PRIMARY KEY);
INSERT INTO @ExpectedUQ (Name) VALUES
    (N'UQ_Caja_Codigo'),
    (N'UQ_NotaCredito_IdDevolucion'),
    (N'UQ_NotaCredito_NumeroNota');

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
    THROW 52263, @MsgUQ, 1;
END;

/* Required CHECK constraints. */
DECLARE @ExpectedChecks TABLE (Name SYSNAME PRIMARY KEY);
INSERT INTO @ExpectedChecks (Name) VALUES
    (N'CK_Caja_Codigo_NoVacio'),
    (N'CK_Caja_Nombre_NoVacio'),
    (N'CK_Caja_Estado'),
    (N'CK_SesionCaja_MontoApertura'),
    (N'CK_SesionCaja_MontoCierre'),
    (N'CK_SesionCaja_Estado'),
    (N'CK_SesionCaja_Cierre'),
    (N'CK_MovimientoCaja_Tipo'),
    (N'CK_MovimientoCaja_Monto'),
    (N'CK_MovimientoCaja_Origen'),
    (N'CK_DevolucionVenta_Motivo_NoVacio'),
    (N'CK_DevolucionVenta_Estado'),
    (N'CK_LineaDevolucion_Cantidad'),
    (N'CK_NotaCredito_Numero_NoVacio'),
    (N'CK_NotaCredito_Monto'),
    (N'CK_NotaCredito_Estado'),
    (N'CK_Reembolso_Monto');

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
    THROW 52264, @MsgChecks, 1;
END;

PRINT 'PASS: Cash and Returns is valid.';
GO
