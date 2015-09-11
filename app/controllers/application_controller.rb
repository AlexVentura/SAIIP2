class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	# protect_from_forgery with: :exception
	protect_from_forgery with: :null_session

	# Para forzar a que esten logueados antes de poder operar
	# cualquier controlador y por ende cualquier vista.
	# Colocarlo en un controladro especifico para indicar el uso en el unicamente 
	# before_filter :authenticate_user!
end
