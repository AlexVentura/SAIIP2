Rails.application.routes.draw do
	root to: 'visitors#index'
	
	devise_for :users
	resources :users

	# ************************ Mis propias rutas ************************
	# URL para listado de facturas por Proveedor
	get 'cxp' => 'proveedor#listarFacturas'
	post 'cxp'=> 'proveedor#listarFacturas'
	# URL para detalelle de Abonos
	get 'cxp/detalle' => 'proveedor#listarAbonos'
	# URL para la valuación
	get 'cxp/valuacion' => 'proveedor#valuacion_cartera'
	post 'cxp/valuacion' => 'proveedor#valuacion_cartera'

	# URL para listado de facturas por Cliente
	get 'cxc' => 'cliente#listarFacturas'
	post 'cxc'=> 'cliente#listarFacturas'
	# URL para detalelle de Abonos
	get 'cxc/detalle' => 'cliente#listarAbonos'
	# URL para la valuación
	get 'cxc/valuacion' => 'cliente#valuacion_cartera'
	post 'cxc/valuacion' => 'cliente#valuacion_cartera'
end
