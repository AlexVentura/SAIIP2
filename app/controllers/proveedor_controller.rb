class ProveedorController < ApplicationController
	# Para forzar a que esten logueados antes de poder operar
	# este controlador y por ende cualquier vista.
	before_filter :authenticate_user!
	
	# layout 'ejemplo'

	def listarFacturas
		if params[:idproveedorNum] # Si id proveedor existe
			# Devolvemos solo las facturas del proveedor indicado

			@codigoProveedor = params[:idproveedorNum]

			# http://apidock.com/rails/ActiveRecord/Querying/find_by_sql
			# find_by_sql(sql, binds = []) public
			# You can use the same string replacement techniques as you can with ActiveRecord#find
			# Post.find_by_sql ["SELECT title FROM posts WHERE author = ? AND created > ?", author_id, start_date]
			@facturas = ComRecepcion.find_by_sql ["
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
				AND ((R.`IdProveedor`) = ?)", @codigoProveedor]
		else
			# Devolvemos todas las facturas de todos los proveedores
			@facturas = ComRecepcion.find_by_sql("
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
				")
		end

		@importe_total = 0
		@facturas.each { |factura|
			@importe_total = @importe_total + factura.SumaDeImporte
		}

		render 'index'
	end

	def listarAbonos
		p '*'*80
		p params

		if params[:id] # Si id de la factura existe
			# Devolvemos los abonos correspondientes a la factura

			codigoFactura = params[:id]
			codigoProveedor = params[:idp]

			@documento = ComRecepcion.find_by_sql ["
				SELECT
					R.`id`,R.`IdProveedor`,P.`Nombre`,R.`Fecha`,R.`Plazo`,
					(DATE_ADD(R.`Fecha`,INTERVAL R.`Plazo` DAY)) AS FechaVence,
					SUM(RD.`Importe_Total`) AS SumaDeImporte,
					P.TCuenta, P.Plazo
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
				AND ((R.id) = ?)
				AND ((R.`IdProveedor`) = ?)", codigoFactura, codigoProveedor]

			@abonos = ProveedorCartera.find_by_sql ["
				SELECT
					PC.id,PC.Fecha,PC.Realiza,PC.Autoriza,PC.Monto,PC.Forma_Pago, PC.Referencia
				FROM
					proveedor_carteras PC
				WHERE
					PC.IdProveedor = ?
				AND
					PC.IdDocumento = ?
				ORDER BY
					PC.id
				;", codigoProveedor, codigoFactura]

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
		else
			# Devolvemos un error
			@documento = 'Null'
			@abonos = 'Null'
		end
	end

	def valuacion_cartera
		facturas = ComRecepcion.find_by_sql("
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
			")
		@total_valuacion = 0
		@total_facturas = facturas.size

		facturas.each { |fac|
			@total_valuacion = @total_valuacion + fac.SumaDeImporte
		}

		# include ActionView::Helpers::NumberHelper
		# @total = number_to_currency(@total_valuacion, :unit => "$ ")

		p '*'*80
		p @total_valuacion
	end
end
