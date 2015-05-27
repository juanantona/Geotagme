class SessionsController < ApplicationController
 
 	def new
		@observer = Observer.new
 		render 'new'
		
 	end
 
 	def create
 		
		observer = Observer.find_by(email: params[:observer][:email])
		if (observer && observer.authenticate(params[:observer][:password]))
			session[:user_id] = observer.id
			session[:role] = 'observer'
		
 			redirect_to dashboard_path
  		else
  			redirect_to login_path 
  		end 
 		
 	end
 
 	def destroy
 		session[:user_id] = nil
 		session[:role] = nil
 			    
		redirect_to login_path 
 		
 	end
 end