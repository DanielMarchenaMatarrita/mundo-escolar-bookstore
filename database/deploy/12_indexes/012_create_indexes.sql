USE MundoEscolar;
GO

-- ============================================================================
-- K. ÍNDICES ÚNICOS FILTRADOS E ÍNDICES DE SOPORTE
-- ============================================================================

CREATE UNIQUE NONCLUSTERED INDEX UX_Proveedor_CodigoProveedor
ON dbo.Proveedor (CodigoProveedor)
WHERE CodigoProveedor IS NOT NULL
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_Libro_ISBN
ON dbo.Libro (ISBN)
WHERE ISBN IS NOT NULL
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_ItemComercial_CodigoBarras
ON dbo.ItemComercial (CodigoBarras)
WHERE CodigoBarras IS NOT NULL
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_Usuario_IdPersona
ON dbo.Usuario (IdPersona)
WHERE IdPersona IS NOT NULL
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_RecepcionCompra_IdMovimientoInventario
ON dbo.RecepcionCompra (IdMovimientoInventario)
WHERE IdMovimientoInventario IS NOT NULL
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_ConteoInventario_IdMovimientoAjuste
ON dbo.ConteoInventario (IdMovimientoAjuste)
WHERE IdMovimientoAjuste IS NOT NULL
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_Venta_IdMovimientoInventario
ON dbo.Venta (IdMovimientoInventario)
WHERE IdMovimientoInventario IS NOT NULL
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_DevolucionVenta_IdMovimientoInventario
ON dbo.DevolucionVenta (IdMovimientoInventario)
WHERE IdMovimientoInventario IS NOT NULL
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_MovimientoCaja_IdPago
ON dbo.MovimientoCaja (IdPago)
WHERE IdPago IS NOT NULL
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_MovimientoCaja_IdReembolso
ON dbo.MovimientoCaja (IdReembolso)
WHERE IdReembolso IS NOT NULL
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_ContactoTercero_Principal
ON dbo.ContactoTercero (IdTercero, TipoContacto)
WHERE Principal = 1
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_DireccionTercero_Principal
ON dbo.DireccionTercero (IdTercero)
WHERE Principal = 1
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_ProveedorItemComercial_Preferido
ON dbo.ProveedorItemComercial (IdItemComercial)
WHERE EsPreferido = 1
ON FG_INDEX;
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_SesionCaja_Abierta
ON dbo.SesionCaja (IdCaja)
WHERE Estado = 'ABIERTA'
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_DireccionTercero_IdTercero
ON dbo.DireccionTercero (IdTercero)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Producto_IdCategoria
ON dbo.Producto (IdCategoria)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Producto_IdMarca
ON dbo.Producto (IdMarca)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Libro_IdEditorial
ON dbo.Libro (IdEditorial)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_LibroAutor_IdAutor
ON dbo.LibroAutor (IdAutor)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_ItemComercial_IdPresentacion
ON dbo.ItemComercial (IdPresentacion)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_ProveedorItemComercial_IdItem
ON dbo.ProveedorItemComercial (IdItemComercial)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Precio_IdConceptoComercial
ON dbo.Precio (IdConceptoComercial)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_CampanaPromocional_IdTemporada
ON dbo.CampanaPromocional (IdTemporada)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Promocion_IdCampana
ON dbo.Promocion (IdCampana)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_PromocionConcepto_IdConcepto
ON dbo.PromocionConcepto (IdConceptoComercial)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_PromocionCategoria_IdCategoria
ON dbo.PromocionCategoria (IdCategoria)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_OrdenCompra_IdProveedor
ON dbo.OrdenCompra (IdProveedor)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_OrdenCompra_IdUsuario
ON dbo.OrdenCompra (IdUsuario)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_LineaOrdenCompra_IdItem
ON dbo.LineaOrdenCompra (IdItemComercial)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_RecepcionCompra_IdOrden
ON dbo.RecepcionCompra (IdOrdenCompra)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_RecepcionCompra_IdUbicacion
ON dbo.RecepcionCompra (IdUbicacionDestino)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_RecepcionCompra_IdUsuario
ON dbo.RecepcionCompra (IdUsuario)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_LineaRecepcion_IdLineaOrden
ON dbo.LineaRecepcion (IdLineaOrden)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_MovimientoInventario_IdUsuario
ON dbo.MovimientoInventario (IdUsuario)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_MovimientoInventario_Fecha
ON dbo.MovimientoInventario (Fecha)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_DetalleMovimiento_ItemUbicacion
ON dbo.DetalleMovimientoInventario (IdItemComercial, IdUbicacion)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Existencia_IdUbicacion
ON dbo.Existencia (IdUbicacion)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_ConteoInventario_IdUbicacion
ON dbo.ConteoInventario (IdUbicacion)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_ConteoInventario_IdUsuario
ON dbo.ConteoInventario (IdUsuario)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_LineaConteo_IdItem
ON dbo.LineaConteo (IdItemComercial)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_ReglaReposicion_IdUbicacion
ON dbo.ReglaReposicion (IdUbicacion)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Venta_IdCliente
ON dbo.Venta (IdCliente)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Venta_IdUsuario
ON dbo.Venta (IdUsuario)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Venta_IdSucursal
ON dbo.Venta (IdSucursal)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Venta_IdSesionCaja
ON dbo.Venta (IdSesionCaja)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Venta_Fecha
ON dbo.Venta (Fecha)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_LineaVenta_IdConcepto
ON dbo.LineaVenta (IdConceptoComercial)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_PromocionAplicada_IdPromocion
ON dbo.PromocionAplicada (IdPromocion)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Pago_IdMetodoPago
ON dbo.Pago (IdMetodoPago)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Pago_IdUsuario
ON dbo.Pago (IdUsuario)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Pago_FechaPago
ON dbo.Pago (FechaPago)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_AplicacionPago_IdCuentaCobrar
ON dbo.AplicacionPago (IdCuentaCobrar)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Caja_IdSucursal
ON dbo.Caja (IdSucursal)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_SesionCaja_IdUsuarioApertura
ON dbo.SesionCaja (IdUsuarioApertura)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_SesionCaja_IdUsuarioCierre
ON dbo.SesionCaja (IdUsuarioCierre)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_MovimientoCaja_IdSesionCaja
ON dbo.MovimientoCaja (IdSesionCaja)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_DevolucionVenta_IdVenta
ON dbo.DevolucionVenta (IdVenta)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_DevolucionVenta_IdUsuario
ON dbo.DevolucionVenta (IdUsuario)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_LineaDevolucion_IdLineaVenta
ON dbo.LineaDevolucion (IdLineaVenta)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_NotaCredito_IdCuentaCobrar
ON dbo.NotaCredito (IdCuentaCobrar)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Reembolso_IdNotaCredito
ON dbo.Reembolso (IdNotaCredito)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Reembolso_IdMetodoPago
ON dbo.Reembolso (IdMetodoPago)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_Reembolso_IdUsuario
ON dbo.Reembolso (IdUsuario)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_UsuarioRol_IdRol
ON dbo.UsuarioRol (IdRol)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_RolPermiso_IdPermiso
ON dbo.RolPermiso (IdPermiso)
ON FG_INDEX;
GO

CREATE NONCLUSTERED INDEX IX_RegistroAuditoria_IdUsuario
ON dbo.RegistroAuditoria (IdUsuario)
ON FG_AUDIT;
GO

CREATE NONCLUSTERED INDEX IX_RegistroAuditoria_Fecha
ON dbo.RegistroAuditoria (Fecha)
ON FG_AUDIT;
GO

