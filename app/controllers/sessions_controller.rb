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
				        			
			redirect_to dashboard_path

		else 
		    redirect_to	login_path, notice: "Wrong email or password"
		end
		
	end

	# used to log a user out
	def destroy
		session[:user_id] = nil
			    
		redirect_to root_path 
		
	end
end
