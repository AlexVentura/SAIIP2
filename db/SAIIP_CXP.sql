-- **************************************************************************
INSERT INTO SAIIP3_development.proveedores
(
	`Nombre`,`Direccion`,`Ciudad`,`Estado`,`CP`,`Telefono`,`RFC`,`TCuenta`,`Plazo`,`created_at`,`updated_at`
)
SELECT
	`Nombre`,`Direccion`,`CiudadProv`,`Edo`,`CP`,`Telefono`,`RFC`,`TCuenta`,`Plazo`,now(),now()
FROM avc_ac_2011.sysproveedores
;

INSERT INTO SAIIP3_development.com_recepciones
(
	`Id_MainTipo`,`IdProveedor`,`Aplica`,`Fecha`,`Hora`,`TipoCompra`,`Plazo`,`Observaciones`,`Referencia`,`Status`,
	`created_at`,`updated_at`
)
SELECT
	`Id_MainTipo`,`IdProveedor`,`Aplica`,`Fecha`,`Hora`,`TipoCompra`,`Plazo`,`Observaciones`,`Referencia`,`Status`,
	now(),now()
FROM avc_ac_2011.comrecepciones
;

INSERT INTO SAIIP3_development.com_recepcion_detalles
(
	`IdCompra`,`IdProducto`,`Cantidad`,`Bultos`,`Costo_Unitario`,`Desc_Unitario`,`Desc_Total`,`Costo_Total`,
	`Impuesto_Total`,`Importe_Total`,`Exento`,`created_at`,`updated_at`
)
SELECT
	`IdCompra`,`IdProducto`,`Cantidad`,`Bultos`,`Costo_Unitario`,`Desc_Unitario`,`Desc_Total`,`Costo_Total`,
	`Impuesto_Total`,`Importe_Total`,`Exento`,now(),now()
FROM avc_ac_2011.comrecepcionesdetalle
;

INSERT INTO SAIIP3_development.proveedor_carteras
(
	`IdProveedor`,`IdDocumento`,`Fecha`,`Hora`,`Realiza`,`Autoriza`,`Monto`,`Forma_Pago`,`Referencia`
)
SELECT
	`IdProveedor`,`IdDocumento`,`Fecha`,`Hora`,`Realiza`,`Autoriza`,`Monto`,`Forma_Pago`,`Referencia`
FROM avc_ac_2011.sysproveedorescartera
;

-- **************************************************************************

-- MUESTRA FACTURAS POR CÓDIGO DE PROVEEDOR
SELECT
	R.`id`,R.`IdProveedor`,P.`Nombre`,R.`Fecha`,R.`Plazo`,
	(DATE_ADD(R.`Fecha`,INTERVAL R.`Plazo` DAY)) AS FechaVence,
	SUM(RD.`Importe_Total`) AS SumaDeImporte
FROM
	com_recepciones R
INNER JOIN
	com_recepcion_detalles RD ON R.`id` = RD.`IdCompra`
INNER JOIN
	proveedores P ON R.`IdProveedor` = P.`id`
GROUP BY
	R.`id`, R.`IdProveedor`, P.`Nombre`, R.`Fecha`, R.`TipoCompra`, P.`Plazo`, (R.`Fecha`)+(R.`Plazo`), R.`Status`
HAVING
	(((R.`TipoCompra`)='CREDITO')
AND ((R.`Status`)='PENDIENTE'))
AND ((R.`IdProveedor`) = 9)
;

-- MUESTRA TODAS LAS FACTURAS DE TODOS LOS PROVEEDOR
SELECT
	R.`id`,R.`IdProveedor`,P.`Nombre`,R.`Fecha`,R.`Plazo`,
	(DATE_ADD(R.`Fecha`,INTERVAL R.`Plazo` DAY)) AS FechaVence,
	SUM(RD.`Importe_Total`) AS SumaDeImporte
FROM
	com_recepciones R
INNER JOIN
	com_recepcion_detalles RD ON R.`id` = RD.`IdCompra`
INNER JOIN
	proveedores P ON R.`IdProveedor` = P.`id`
GROUP BY
	R.`id`, R.`IdProveedor`, P.`Nombre`, R.`Fecha`, R.`TipoCompra`, P.`Plazo`, (R.`Fecha`)+(R.`Plazo`), R.`Status`
HAVING
	(((R.`TipoCompra`)='CREDITO')
AND ((R.`Status`)='PENDIENTE'));

-- MUESTRA ABONOS POR CÓGIDOG DE FACTURA POR CÓDIGO DE PROVEEDOR
SELECT
	PC.`id`,PC.`IdProveedor`,PC.`IdDocumento`,PC.`Fecha`,PC.`Hora`,PC.`Realiza`,PC.`Autoriza`,PC.`Monto`,PC.`Forma_Pago`,PC.`Referencia`
FROM
	proveedor_carteras PC
WHERE
	PC.`IdProveedor` = '9'
AND
	PC.`IdDocumento` = '45'
ORDER BY
	PC.`id`
;
