class SessionsController < ApplicationController

	def new
		@observer = Observer.new
		render 'new'
	end

	def create
		
		@observer = Observer.find_by(email: params[:observer][:email])
		
		if (@user && @user.authenticate(params[:observer][:password]))
			session[:user_id] = observer.id
				        			
			redirect_to dashboard_path

		else 
		    redirect_to	login_path, notice: "Wrong email or password"
		end
		
	end

	# used to log a user out
	def destroy
		session[:user_id] = nil
			    
		redirect_to login_path 
		
	end
end
