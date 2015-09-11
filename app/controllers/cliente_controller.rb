class ClienteController < ApplicationController
	# Para forzar a que esten logueados antes de poder operar
	# este controlador y por ende cualquier vista.
	before_filter :authenticate_user!
	
	# layout 'ejemplo'

	def listarFacturas
		if params[:idClienteNum] # Si id cliente existe
			# Devolvemos solo las facturas del cliente indicado

			@codigoCliente = params[:idClienteNum]

			@facturas = PvtFacturacion.find_by_sql ["
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
				AND ((F.`Cliente`) = ?))", @codigoCliente]
		else
			# Devolvemos todas las facturas de todos los clientes
			@facturas = PvtFacturacion.find_by_sql("
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
				AND	((F.Status)='PENDIENTE'));
				")
		end

		@importe_total = 0
		@facturas.each { |factura|
			@importe_total = @importe_total + factura.SumaDeImporte
		}

		render 'index'
	end

	def listarAbonos
		if params[:id] # Si id de la factura existe
			# Devolvemos los abonos correspondientes a la factura

			codigoFactura = params[:id]
			codigoCliente = params[:idc]

			@documento = PvtFacturacion.find_by_sql ["
				SELECT
					F.IdVenta,F.Fac_Tipo,F.Cliente,C.Nombre,F.Fecha,C.Plazo,
					(DATE_ADD(F.Fecha,INTERVAL C.Plazo DAY)) AS FechaVence,
					Sum(FD.Importe_Total) AS SumaDeImporte,
					C.TCuenta, C.Plazo
				FROM
					clientes C
				INNER JOIN
					(pvt_facturaciones F
				INNER JOIN
					pvt_facturacion_detalles FD ON F.IdVenta = FD.IdVenta) ON C.id = F.Cliente
				GROUP BY
					F.IdVenta, F.Fac_Tipo, F.Cliente, C.Nombre, F.Fecha, C.Plazo, (F.Fecha)+(C.Plazo), F.Status
				HAVING (
					((F.IdVenta)= ?)
				AND ((F.Fac_Tipo)=2)
				AND ((F.Cliente)= ?)
				AND ((F.Status)='PENDIENTE'))", codigoFactura, codigoCliente]

			@abonos = ClienteCartera.find_by_sql ["
				SELECT
					CC.id,CC.Fecha,CC.Realiza,CC.Autoriza,CC.Monto,CC.Forma_Pago,CC.Referencia
				FROM
					cliente_carteras CC
				WHERE
					CC.IdCliente = ?
				AND
					CC.IdDocumento = ?
				ORDER BY
					CC.id
				;", codigoCliente, codigoFactura]

			if Time.now > @documento[0].FechaVence
				@status = 1
			else
				@status = 0
			end

			@total_abonos = 0
			@abonos.each { |abono|
				@total_abonos = @total_abonos + abono.Monto
			}
			@saldo_actual = @documento[0].SumaDeImporte - @total_abonos

			p '*'*80
			p 'LLego al True'
		else
			# Devolvemos un error
			@documento = 'Null'
			@abonos = 'Null'
		end
	end

	def valuacion_cartera
		facturas = PvtFacturacion.find_by_sql("
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
			AND	((F.Status)='PENDIENTE'));
			")
		@total_valuacion = 0
		@total_facturas = facturas.size

		facturas.each { |fac|
			@total_valuacion = @total_valuacion + fac.SumaDeImporte
		}

		# include ActionView::Helpers::NumberHelper
		# @total = number_to_currency(@total_valuacion, :unit => "$ ")
	end
end
