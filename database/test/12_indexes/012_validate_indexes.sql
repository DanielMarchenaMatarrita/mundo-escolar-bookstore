USE MundoEscolar;
GO

PRINT '=== VALIDATION: Supporting and Filtered Indexes ===';
GO

DECLARE @Missing NVARCHAR(2048);

DECLARE @ExpectedIndexes TABLE (
    Name SYSNAME PRIMARY KEY,
    IsUnique BIT NOT NULL,
    IsFiltered BIT NOT NULL
);

INSERT INTO @ExpectedIndexes (Name, IsUnique, IsFiltered) VALUES
    (N'UX_Proveedor_CodigoProveedor', 1, 1),
    (N'UX_Libro_ISBN', 1, 1),
    (N'UX_ItemComercial_CodigoBarras', 1, 1),
    (N'UX_Usuario_IdPersona', 1, 1),
    (N'UX_RecepcionCompra_IdMovimientoInventario', 1, 1),
    (N'UX_ConteoInventario_IdMovimientoAjuste', 1, 1),
    (N'UX_Venta_IdMovimientoInventario', 1, 1),
    (N'UX_DevolucionVenta_IdMovimientoInventario', 1, 1),
    (N'UX_MovimientoCaja_IdPago', 1, 1),
    (N'UX_MovimientoCaja_IdReembolso', 1, 1),
    (N'UX_ContactoTercero_Principal', 1, 1),
    (N'UX_DireccionTercero_Principal', 1, 1),
    (N'UX_ProveedorItemComercial_Preferido', 1, 1),
    (N'UX_SesionCaja_Abierta', 1, 1),
    (N'IX_DireccionTercero_IdTercero', 0, 0),
    (N'IX_Producto_IdCategoria', 0, 0),
    (N'IX_Producto_IdMarca', 0, 0),
    (N'IX_Libro_IdEditorial', 0, 0),
    (N'IX_LibroAutor_IdAutor', 0, 0),
    (N'IX_ItemComercial_IdPresentacion', 0, 0),
    (N'IX_ProveedorItemComercial_IdItem', 0, 0),
    (N'IX_Precio_IdConceptoComercial', 0, 0),
    (N'IX_CampanaPromocional_IdTemporada', 0, 0),
    (N'IX_Promocion_IdCampana', 0, 0),
    (N'IX_PromocionConcepto_IdConcepto', 0, 0),
    (N'IX_PromocionCategoria_IdCategoria', 0, 0),
    (N'IX_OrdenCompra_IdProveedor', 0, 0),
    (N'IX_OrdenCompra_IdUsuario', 0, 0),
    (N'IX_LineaOrdenCompra_IdItem', 0, 0),
    (N'IX_RecepcionCompra_IdOrden', 0, 0),
    (N'IX_RecepcionCompra_IdUbicacion', 0, 0),
    (N'IX_RecepcionCompra_IdUsuario', 0, 0),
    (N'IX_LineaRecepcion_IdLineaOrden', 0, 0),
    (N'IX_MovimientoInventario_IdUsuario', 0, 0),
    (N'IX_MovimientoInventario_Fecha', 0, 0),
    (N'IX_DetalleMovimiento_ItemUbicacion', 0, 0),
    (N'IX_Existencia_IdUbicacion', 0, 0),
    (N'IX_ConteoInventario_IdUbicacion', 0, 0),
    (N'IX_ConteoInventario_IdUsuario', 0, 0),
    (N'IX_LineaConteo_IdItem', 0, 0),
    (N'IX_ReglaReposicion_IdUbicacion', 0, 0),
    (N'IX_Venta_IdCliente', 0, 0),
    (N'IX_Venta_IdUsuario', 0, 0),
    (N'IX_Venta_IdSucursal', 0, 0),
    (N'IX_Venta_IdSesionCaja', 0, 0),
    (N'IX_Venta_Fecha', 0, 0),
    (N'IX_LineaVenta_IdConcepto', 0, 0),
    (N'IX_PromocionAplicada_IdPromocion', 0, 0),
    (N'IX_Pago_IdMetodoPago', 0, 0),
    (N'IX_Pago_IdUsuario', 0, 0),
    (N'IX_Pago_FechaPago', 0, 0),
    (N'IX_AplicacionPago_IdCuentaCobrar', 0, 0),
    (N'IX_Caja_IdSucursal', 0, 0),
    (N'IX_SesionCaja_IdUsuarioApertura', 0, 0),
    (N'IX_SesionCaja_IdUsuarioCierre', 0, 0),
    (N'IX_MovimientoCaja_IdSesionCaja', 0, 0),
    (N'IX_DevolucionVenta_IdVenta', 0, 0),
    (N'IX_DevolucionVenta_IdUsuario', 0, 0),
    (N'IX_LineaDevolucion_IdLineaVenta', 0, 0),
    (N'IX_NotaCredito_IdCuentaCobrar', 0, 0),
    (N'IX_Reembolso_IdNotaCredito', 0, 0),
    (N'IX_Reembolso_IdMetodoPago', 0, 0),
    (N'IX_Reembolso_IdUsuario', 0, 0),
    (N'IX_UsuarioRol_IdRol', 0, 0),
    (N'IX_RolPermiso_IdPermiso', 0, 0),
    (N'IX_RegistroAuditoria_IdUsuario', 0, 0),
    (N'IX_RegistroAuditoria_Fecha', 0, 0);

SELECT @Missing = STRING_AGG(CONVERT(NVARCHAR(MAX), e.Name), N', ')
FROM @ExpectedIndexes AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM sys.indexes AS i
    JOIN sys.data_spaces AS ds
        ON ds.data_space_id = i.data_space_id
    WHERE i.name = e.Name
      AND i.type_desc = N'NONCLUSTERED'
      AND i.is_unique = e.IsUnique
      AND i.has_filter = e.IsFiltered
      AND i.is_disabled = 0
      AND ds.name = CASE
          WHEN e.Name IN (
              N'IX_RegistroAuditoria_IdUsuario',
              N'IX_RegistroAuditoria_Fecha'
          ) THEN N'FG_AUDIT'
          ELSE N'FG_INDEX'
      END
);

IF @Missing IS NOT NULL
BEGIN
    DECLARE @MsgIndexes NVARCHAR(2048) =
        N'Validation failed: missing/incorrect index(es): ' + @Missing;
    THROW 52401, @MsgIndexes, 1;
END;

IF (SELECT COUNT(*) FROM @ExpectedIndexes) <> 67
BEGIN
    THROW 52402, N'Validation definition error: unexpected index manifest size.', 1;
END;

PRINT 'PASS: Supporting and filtered indexes are valid (67 expected indexes).';
GO

