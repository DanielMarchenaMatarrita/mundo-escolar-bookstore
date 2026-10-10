USE MundoEscolar;
GO

-- ============================================================================
-- L. REGLAS DEL MODELO LÓGICO DELIBERADAMENTE DIFERIDAS A FASE 5.4
-- ============================================================================
-- Estas reglas requieren validar varias filas/tablas o una operación completa:
--
--  1. Tercero = Persona XOR Organizacion (total y disjunta).
--  2. ConceptoComercial = ItemComercial XOR Servicio (total y disjunta).
--  3. CategoriaProducto no puede formar ciclos jerárquicos.
--  4. Vigencias de Precio para una misma lista/concepto no se solapan.
--  5. Escalas de un Precio no se solapan.
--  6. CampanaPromocional debe quedar dentro de su TemporadaComercial.
--  7. Promocion debe quedar dentro de su CampanaPromocional cuando exista.
--  8. LineaRecepcion debe pertenecer a la misma OrdenCompra de la RecepcionCompra.
--  9. RecepcionCompra.FechaRecepcion >= OrdenCompra.FechaOrden.
-- 10. SUM(LineaRecepcion.CantidadRecibida) <= LineaOrdenCompra.CantidadSolicitada.
-- 11. Un traslado de inventario conserva cantidad neta = 0 por item.
-- 12. Las salidas de inventario no pueden dejar Existencia negativa.
-- 13. TrabajoServicio solo puede corresponder a una LineaVenta cuyo concepto sea Servicio.
-- 14. Crédito exige cliente identificado con CreditoHabilitado = 1.
-- 15. PromocionAplicada debe ser elegible y vigente para la LineaVenta.
-- 16. SUM(AplicacionPago.MontoAplicado) <= Pago.Monto.
-- 17. Una cuenta no puede quedar sobrepagada.
-- 18. Varias cuentas cubiertas por un mismo Pago deben corresponder al mismo cliente.
-- 19. CuentaPorCobrar.FechaVencimiento >= Factura.FechaEmision (comparación en fecha local de negocio).
-- 20. Cuando aplique cronológicamente, Pago.FechaPago no precede a la emisión de la factura pagada.
-- 21. LineaDevolucion debe pertenecer a la Venta de DevolucionVenta.
-- 22. DevolucionVenta.Fecha >= Venta.Fecha.
-- 23. Cantidad devuelta acumulada <= cantidad vendida.
-- 24. NotaCredito.IdCuentaCobrar debe corresponder a la factura de la venta devuelta.
-- 25. SUM(Reembolso.Monto) <= NotaCredito.MontoCredito.
-- 26. Venta.IdSesionCaja, cuando exista, debe pertenecer a la misma Sucursal de Venta.
-- 27. MetodoPago.RequiereReferencia = 1 implica Pago.Referencia NOT NULL.
-- 28. PromocionAplicada total debe ser coherente con LineaVenta.DescuentoAplicado.
--
-- Se implementarán mediante procedimientos transaccionales y, solo donde sea
-- necesario como defensa contra DML directo, triggers acotados.
GO
