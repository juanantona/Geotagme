class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user # esto lo pones para que el metodo este disponible
                              # en todas las vistas
  def current_user
  	if @current_user.nil?
  		@current_user = User.find_by_id(session[:user_id])
  	end	
  	@current_user
  end

  def authorize
  	if current_user.nil?
  		redirect_to login_path
  	end
  end

  def dropbox_client
    @dropboxclient ||= Dropbox::API::Client.new(:token => session[:access_token], :secret => session[:access_secret_token])
  end 

end
