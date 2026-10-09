USE MundoEscolar;
GO

-- ============================================================================
-- M. VALIDACIÓN POST-DESPLIEGUE
-- ============================================================================
DECLARE @ExpectedTables INT = 61;
DECLARE @ActualTables INT;

SELECT @ActualTables = COUNT(*)
FROM sys.tables
WHERE schema_id = SCHEMA_ID(N'dbo')
  AND name IN (N'Tercero',N'Persona',N'Organizacion',N'Cliente',N'Proveedor',N'ContactoTercero',N'DireccionTercero',N'CategoriaProducto',N'Marca',N'Producto',N'Editorial',N'Libro',N'Autor',N'LibroAutor',N'Presentacion',N'ConceptoComercial',N'ItemComercial',N'Servicio',N'ProveedorItemComercial',N'ListaPrecio',N'Precio',N'EscalaPrecio',N'TemporadaComercial',N'CampanaPromocional',N'Promocion',N'PromocionConcepto',N'PromocionCategoria',N'OrdenCompra',N'LineaOrdenCompra',N'RecepcionCompra',N'LineaRecepcion',N'Sucursal',N'UbicacionInventario',N'MovimientoInventario',N'DetalleMovimientoInventario',N'Existencia',N'ConteoInventario',N'LineaConteo',N'ReglaReposicion',N'Venta',N'LineaVenta',N'PromocionAplicada',N'TrabajoServicio',N'Factura',N'CuentaPorCobrar',N'MetodoPago',N'Pago',N'AplicacionPago',N'Caja',N'SesionCaja',N'MovimientoCaja',N'DevolucionVenta',N'LineaDevolucion',N'NotaCredito',N'Reembolso',N'Usuario',N'Rol',N'Permiso',N'UsuarioRol',N'RolPermiso',N'RegistroAuditoria');

IF @ActualTables <> @ExpectedTables
BEGIN
    DECLARE @MsgTables NVARCHAR(2048) =
        N'Validación fallida: se esperaban 61 tablas canónicas y se encontraron '
        + CONVERT(NVARCHAR(20), @ActualTables) + N'.';
    THROW 51000, @MsgTables, 1;
END;

DECLARE @ExpectedFKs INT = 91;
DECLARE @ActualFKs INT;

SELECT @ActualFKs = COUNT(*)
FROM sys.foreign_keys
WHERE schema_id = SCHEMA_ID(N'dbo');

IF @ActualFKs <> @ExpectedFKs
BEGIN
    DECLARE @MsgFK NVARCHAR(2048) =
        N'Validación fallida: se esperaban 91 foreign keys y se encontraron '
        + CONVERT(NVARCHAR(20), @ActualFKs) + N'.';
    THROW 51001, @MsgFK, 1;
END;

IF EXISTS (
    SELECT 1
    FROM sys.foreign_keys
    WHERE schema_id = SCHEMA_ID(N'dbo')
      AND (is_disabled = 1 OR is_not_trusted = 1)
)
BEGIN
    THROW 51002, N'Validación fallida: existe al menos una FK deshabilitada o no confiable.', 1;
END;

-- Validación de arquitectura física 5.3A/5.3B.
IF NOT EXISTS (SELECT 1 FROM sys.filegroups WHERE name = N'FG_DATA' AND is_default = 1)
    THROW 51003, N'Validación fallida: FG_DATA no existe o no es el filegroup DEFAULT.', 1;

IF NOT EXISTS (SELECT 1 FROM sys.filegroups WHERE name = N'FG_INDEX')
    THROW 51004, N'Validación fallida: FG_INDEX no existe.', 1;

IF NOT EXISTS (SELECT 1 FROM sys.filegroups WHERE name = N'FG_AUDIT')
    THROW 51005, N'Validación fallida: FG_AUDIT no existe.', 1;

IF (SELECT recovery_model_desc FROM sys.databases WHERE name = DB_NAME()) <> N'FULL'
    THROW 51006, N'Validación fallida: MundoEscolar no está en RECOVERY FULL.', 1;

DECLARE @TablesData INT;
DECLARE @TablesAudit INT;

SELECT @TablesData = COUNT(*)
FROM sys.tables t
JOIN sys.indexes i ON i.object_id = t.object_id AND i.index_id = 1
JOIN sys.data_spaces ds ON ds.data_space_id = i.data_space_id
WHERE t.schema_id = SCHEMA_ID(N'dbo')
  AND ds.name = N'FG_DATA';

SELECT @TablesAudit = COUNT(*)
FROM sys.tables t
JOIN sys.indexes i ON i.object_id = t.object_id AND i.index_id = 1
JOIN sys.data_spaces ds ON ds.data_space_id = i.data_space_id
WHERE t.schema_id = SCHEMA_ID(N'dbo')
  AND ds.name = N'FG_AUDIT';

IF @TablesData <> 60
BEGIN
    DECLARE @MsgDataFG NVARCHAR(2048) =
        N'Validación fallida: se esperaban 60 tablas/clustered indexes en FG_DATA y se encontraron '
        + CONVERT(NVARCHAR(20), @TablesData) + N'.';
    THROW 51007, @MsgDataFG, 1;
END;

IF @TablesAudit <> 1
BEGIN
    DECLARE @MsgAuditFG NVARCHAR(2048) =
        N'Validación fallida: se esperaba 1 tabla/clustered index en FG_AUDIT y se encontraron '
        + CONVERT(NVARCHAR(20), @TablesAudit) + N'.';
    THROW 51008, @MsgAuditFG, 1;
END;

IF NOT EXISTS (
    SELECT 1
    FROM sys.tables t
    JOIN sys.indexes i ON i.object_id = t.object_id AND i.index_id = 1
    JOIN sys.data_spaces ds ON ds.data_space_id = i.data_space_id
    WHERE t.name = N'RegistroAuditoria'
      AND t.schema_id = SCHEMA_ID(N'dbo')
      AND ds.name = N'FG_AUDIT'
)
    THROW 51009, N'Validación fallida: RegistroAuditoria no está almacenada en FG_AUDIT.', 1;

DECLARE @OperationalNonclusteredFGIndex INT;
DECLARE @AuditNonclusteredFGAudit INT;

SELECT @OperationalNonclusteredFGIndex = COUNT(*)
FROM sys.indexes i
JOIN sys.tables t ON t.object_id = i.object_id
JOIN sys.data_spaces ds ON ds.data_space_id = i.data_space_id
WHERE t.schema_id = SCHEMA_ID(N'dbo')
  AND t.name <> N'RegistroAuditoria'
  AND i.type = 2
  AND ds.name = N'FG_INDEX';

SELECT @AuditNonclusteredFGAudit = COUNT(*)
FROM sys.indexes i
JOIN sys.tables t ON t.object_id = i.object_id
JOIN sys.data_spaces ds ON ds.data_space_id = i.data_space_id
WHERE t.schema_id = SCHEMA_ID(N'dbo')
  AND t.name = N'RegistroAuditoria'
  AND i.type = 2
  AND ds.name = N'FG_AUDIT';

IF @OperationalNonclusteredFGIndex <> 91
BEGIN
    DECLARE @MsgIndexFG NVARCHAR(2048) =
        N'Validación fallida: se esperaban 91 índices nonclustered operacionales en FG_INDEX y se encontraron '
        + CONVERT(NVARCHAR(20), @OperationalNonclusteredFGIndex) + N'.';
    THROW 51011, @MsgIndexFG, 1;
END;

IF @AuditNonclusteredFGAudit <> 2
BEGIN
    DECLARE @MsgAuditIndexFG NVARCHAR(2048) =
        N'Validación fallida: se esperaban 2 índices nonclustered de auditoría en FG_AUDIT y se encontraron '
        + CONVERT(NVARCHAR(20), @AuditNonclusteredFGAudit) + N'.';
    THROW 51012, @MsgAuditIndexFG, 1;
END;

SELECT
    @ActualTables AS TablasCanonicas,
    @ActualFKs AS ForeignKeys,
    @TablesData AS TablasEnFG_DATA,
    @TablesAudit AS TablasEnFG_AUDIT,
    @OperationalNonclusteredFGIndex AS IndicesOperacionalesEnFG_INDEX,
    @AuditNonclusteredFGAudit AS IndicesAuditoriaEnFG_AUDIT,
    (SELECT recovery_model_desc FROM sys.databases WHERE name = DB_NAME()) AS RecoveryModel,
    N'PASS' AS EstadoValidacion;
GO
