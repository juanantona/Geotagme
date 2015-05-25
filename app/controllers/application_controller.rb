class ApplicationController < ActionController::Base
 
  protect_from_forgery with: :exception

  helper_method :current_user 
  
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
end
