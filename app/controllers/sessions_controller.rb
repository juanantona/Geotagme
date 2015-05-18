class SessionsController < ApplicationController

	# renders the login form
	def new
		render 'new'
	end

	# used to log a user in
	def create
		
		@user = User.find_by(email: params[:email])
		
		if (@user && @user.authenticate(params[:password]))
			session[:user_id] = @user.id
			session[:access_token]  = @user.token
	        session[:access_secret_token]  = @user.secret
			
			redirect_to welcome_path
		else 
		    redirect_to	login_path, notice: "Wrong email or password"
		end
		
	end

	# used to log a user out
	def destroy
		session[:user_id] = nil
		session[:access_token]  = nil
	    session[:access_secret_token]  = nil
		redirect_to login_path 
		
	end
end
