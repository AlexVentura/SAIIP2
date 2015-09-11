-- **************************************************************************
INSERT INTO SAIIP2_development.clientes
(
	`Nombre`,`Direccion`,`Ciudad`,`Estado`,`CP`,`Telefono`,`RFC`,`TCuenta`,`Plazo`,`Limite`,`Status`,
	`created_at`,`updated_at`
)
SELECT
	`Nombre`,`Direccion`,`CiudadProv`,`Edo`,`CP`,`Telefono`,`RFC`,`TCuenta`,`Plazo`,`Limite`,`Status`,
	now(),now()
FROM avc_ac_2011.sysclientes
;

INSERT INTO SAIIP2_development.pvt_facturaciones
(
	`IdVenta`,`IdCaja`,`Fac_Tipo`,`Fac_Cajero`,`Fac_Vendedor`,`Cliente`,`Fecha`,`Hora`,`Status`,`Efectivo`,`Tarjeta`,
	`Cheque`,`Vales`,`Cupones`,`Motivo`,`Apertura`
)
SELECT
	`IdVenta`,`IdCaja`,`Fac_Tipo`,`Fac_Cajero`,`Fac_Vendedor`,`Cliente`,`Fecha`,`Hora`,`Status`,`Efectivo`,`Tarjeta`,
	`Cheque`,`Vales`,`Cupones`,`Motivo`,`Apertura`
FROM avc_ac_2011.pvtfacturacion
;

INSERT INTO SAIIP2_development.pvt_facturacion_detalles
(
	`IdVenta`,`IdCaja`,`IdProducto`,`Cantidad`,`Precio_Unitario`,`Desc_Unitario`,`Desc_Total`,`Costo_Total`,
	`Impuesto_Total`,`Importe_Total`,`Exento`
)
SELECT
	`IdVenta`,`IdCaja`,`IdProducto`,`Cantidad`,`Precio_Unitario`,`Desc_Unitario`,`Desc_Total`,`Costo_Total`,
	`Impuesto_Total`,`Importe_Total`,`Exento`
FROM avc_ac_2011.pvtfacturaciondetalle
;

INSERT INTO SAIIP2_development.cliente_carteras
(
	`IdCliente`,`IdDocumento`,`Fecha`,`Hora`,`Realiza`,`Autoriza`,`Monto`,`Forma_pago`,`Referencia`
)
SELECT
	`IdCliente`,`IdDocumento`,`Fecha`,`Hora`,`Realiza`,`Autoriza`,`Monto`,`Forma_Pago`,`Referencia`
FROM avc_ac_2011.sysclientescartera
;

-- **************************************************************************

-- MUESTRA TODAS LAS FACTURAS DE TODOS LOS CLIENTE
SELECT
	F.IdVenta,F.Fac_Tipo,F.Cliente,C.Nombre,F.Fecha,C.Plazo,
	(DATE_ADD(F.Fecha,INTERVAL C.Plazo DAY)) AS FechaVence,
	SUM(FD.Importe_Total) AS SumaDeImporte
FROM
	pvt_facturaciones F
INNER JOIN
	pvt_facturacion_detalles FD ON F.IdVenta = FD.IdVenta AND F.IdCaja = FD.IdCaja
INNER JOIN
	clientes C ON F.Cliente = C.id
GROUP BY
	F.IdVenta,F.Fac_Tipo,F.Cliente,C.Nombre,F.Fecha,C.Plazo,(F.Fecha)+(C.Plazo),F.Status
HAVING
	(((F.Fac_Tipo)=2)
AND	((F.Status)='PENDIENTE')
);

-- MUESTRA FACTURAS POR CÓDIGO DE CLIENTE
SELECT
	F.IdVenta,F.Fac_Tipo,F.Cliente,C.Nombre,F.Fecha,C.Plazo,
	(DATE_ADD(F.Fecha,INTERVAL C.Plazo DAY)) AS FechaVence,
	SUM(FD.Importe_Total) AS SumaDeImporte
FROM
	pvt_facturaciones F
INNER JOIN
	pvt_facturacion_detalles FD ON F.IdVenta = FD.IdVenta AND F.IdCaja = FD.IdCaja
INNER JOIN
	clientes C ON F.Cliente = C.id
GROUP BY
	F.IdVenta,F.Fac_Tipo,F.Cliente,C.Nombre,F.Fecha,C.Plazo,(F.Fecha)+(C.Plazo),F.Status
HAVING
	(((F.Fac_Tipo)=2)
AND	((F.Status)='PENDIENTE')
AND ((F.`Cliente`=28))
);

-- MUESTRA DATOS DE UN DOCUMENTO POR CLIENTE PARA PAGINA ENCABEZADO DE ABONOS
SELECT
	F.IdVenta,F.Fac_Tipo,F.Cliente,C.Nombre,F.Fecha,C.Plazo,
	(DATE_ADD(F.Fecha,INTERVAL C.Plazo DAY)) AS FechaVence,
	Sum(FD.Importe_Total) AS SumaDeImporte
FROM clientes C
INNER JOIN (pvt_facturaciones F
INNER JOIN pvt_facturacion_detalles FD ON F.IdVenta = FD.IdVenta) ON C.id = F.Cliente
GROUP BY F.IdVenta, F.Fac_Tipo, F.Cliente, C.Nombre, F.Fecha, C.Plazo, (F.Fecha)+(C.Plazo), F.Status
HAVING (
	((F.IdVenta)=111)
AND ((F.Fac_Tipo)=2)
AND ((F.Cliente)=28)
AND ((F.Status)='PENDIENTE')
);

-- MUESTRA ABONOS POR CÓGIDOG DE FACTURA POR CÓDIGO DE CLIENTE
SELECT
	CC.`id`,CC.`IdCliente`,CC.`IdDocumento`,CC.`Fecha`,CC.`Hora`,CC.`Realiza`,CC.`Autoriza`,CC.`Monto`,CC.`Forma_Pago`,CC.`Referencia`
FROM
	cliente_carteras CC
WHERE
	CC.IdCliente=28
AND
	CC.IdDocumento=11
ORDER BY
	CC.`id`
;
