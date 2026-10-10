USE MundoEscolar;
GO

PRINT '=== VALIDATION: Foreign Keys ===';
GO

DECLARE @Missing NVARCHAR(2048);

DECLARE @ExpectedFK TABLE (Name SYSNAME PRIMARY KEY);
INSERT INTO @ExpectedFK (Name) VALUES
    (N'FK_Persona_Tercero'),
    (N'FK_Organizacion_Tercero'),
    (N'FK_Cliente_Tercero'),
    (N'FK_Proveedor_Tercero'),
    (N'FK_ContactoTercero_Tercero'),
    (N'FK_DireccionTercero_Tercero'),
    (N'FK_CategoriaProducto_Padre'),
    (N'FK_Producto_CategoriaProducto'),
    (N'FK_Producto_Marca'),
    (N'FK_Libro_Producto'),
    (N'FK_Libro_Editorial'),
    (N'FK_LibroAutor_Libro'),
    (N'FK_LibroAutor_Autor'),
    (N'FK_ItemComercial_ConceptoComercial'),
    (N'FK_ItemComercial_Producto'),
    (N'FK_ItemComercial_Presentacion'),
    (N'FK_Servicio_ConceptoComercial'),
    (N'FK_ProveedorItem_Proveedor'),
    (N'FK_ProveedorItem_Item'),
    (N'FK_Precio_ListaPrecio'),
    (N'FK_Precio_ConceptoComercial'),
    (N'FK_EscalaPrecio_Precio'),
    (N'FK_Campana_Temporada'),
    (N'FK_Promocion_Campana'),
    (N'FK_PromocionConcepto_Promocion'),
    (N'FK_PromocionConcepto_Concepto'),
    (N'FK_PromocionCategoria_Promocion'),
    (N'FK_PromocionCategoria_Categoria'),
    (N'FK_Usuario_Persona'),
    (N'FK_UsuarioRol_Usuario'),
    (N'FK_UsuarioRol_Rol'),
    (N'FK_RolPermiso_Rol'),
    (N'FK_RolPermiso_Permiso'),
    (N'FK_RegistroAuditoria_Usuario'),
    (N'FK_UbicacionInventario_Sucursal'),
    (N'FK_MovimientoInventario_Usuario'),
    (N'FK_DetalleMovimiento_Movimiento'),
    (N'FK_DetalleMovimiento_Item'),
    (N'FK_DetalleMovimiento_Ubicacion'),
    (N'FK_Existencia_Item'),
    (N'FK_Existencia_Ubicacion'),
    (N'FK_ConteoInventario_Ubicacion'),
    (N'FK_ConteoInventario_Usuario'),
    (N'FK_ConteoInventario_Movimiento'),
    (N'FK_LineaConteo_Conteo'),
    (N'FK_LineaConteo_Item'),
    (N'FK_ReglaReposicion_Item'),
    (N'FK_ReglaReposicion_Ubicacion'),
    (N'FK_OrdenCompra_Proveedor'),
    (N'FK_OrdenCompra_Usuario'),
    (N'FK_LineaOrdenCompra_Orden'),
    (N'FK_LineaOrdenCompra_Item'),
    (N'FK_RecepcionCompra_Orden'),
    (N'FK_RecepcionCompra_Ubicacion'),
    (N'FK_RecepcionCompra_Usuario'),
    (N'FK_RecepcionCompra_Movimiento'),
    (N'FK_LineaRecepcion_Recepcion'),
    (N'FK_LineaRecepcion_LineaOrden'),
    (N'FK_Caja_Sucursal'),
    (N'FK_SesionCaja_Caja'),
    (N'FK_SesionCaja_UsuarioApertura'),
    (N'FK_SesionCaja_UsuarioCierre'),
    (N'FK_Venta_Cliente'),
    (N'FK_Venta_Usuario'),
    (N'FK_Venta_Sucursal'),
    (N'FK_Venta_SesionCaja'),
    (N'FK_Venta_MovimientoInventario'),
    (N'FK_LineaVenta_Venta'),
    (N'FK_LineaVenta_Concepto'),
    (N'FK_PromocionAplicada_LineaVenta'),
    (N'FK_PromocionAplicada_Promocion'),
    (N'FK_TrabajoServicio_LineaVenta'),
    (N'FK_Factura_Venta'),
    (N'FK_CuentaPorCobrar_Factura'),
    (N'FK_Pago_MetodoPago'),
    (N'FK_Pago_Usuario'),
    (N'FK_AplicacionPago_Pago'),
    (N'FK_AplicacionPago_Cuenta'),
    (N'FK_DevolucionVenta_Venta'),
    (N'FK_DevolucionVenta_Usuario'),
    (N'FK_DevolucionVenta_Movimiento'),
    (N'FK_LineaDevolucion_Devolucion'),
    (N'FK_LineaDevolucion_LineaVenta'),
    (N'FK_NotaCredito_Devolucion'),
    (N'FK_NotaCredito_Cuenta'),
    (N'FK_Reembolso_NotaCredito'),
    (N'FK_Reembolso_MetodoPago'),
    (N'FK_Reembolso_Usuario'),
    (N'FK_MovimientoCaja_Sesion'),
    (N'FK_MovimientoCaja_Pago'),
    (N'FK_MovimientoCaja_Reembolso');

SELECT @Missing = STRING_AGG(CONVERT(NVARCHAR(MAX), e.Name), N', ')
FROM @ExpectedFK AS e
WHERE NOT EXISTS (
    SELECT 1
    FROM sys.foreign_keys AS fk
    WHERE fk.name = e.Name
      AND fk.is_disabled = 0
      AND fk.is_not_trusted = 0
      AND fk.delete_referential_action_desc = N'NO_ACTION'
      AND fk.update_referential_action_desc = N'NO_ACTION'
);

IF @Missing IS NOT NULL
BEGIN
    DECLARE @MsgFK NVARCHAR(2048) =
        N'Validation failed: missing, disabled, untrusted, or non-NO_ACTION FK(s): ' + @Missing;
    THROW 52301, @MsgFK, 1;
END;

IF (SELECT COUNT(*) FROM @ExpectedFK) <> 91
BEGIN
    THROW 52302, N'Validation definition error: unexpected FK manifest size.', 1;
END;

PRINT 'PASS: Foreign Keys are valid (91 expected constraints).';
GO
