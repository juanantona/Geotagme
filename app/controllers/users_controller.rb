class UsersController < ApplicationController

	def authorize
	    consumer = Dropbox::API::OAuth.consumer(:authorize)
	    request_token = consumer.get_request_token
	    session[:request_token] = request_token.token
	    session[:request_token_secret] = request_token.secret
	    redirect_to request_token.authorize_url(:oauth_callback => "http://#{request.host_with_port}/dropbox/callback")
    end

    def callback
	    
	    consumer = Dropbox::API::OAuth.consumer(:authorize)
	    hash = { oauth_token: session[:request_token], oauth_token_secret: session[:request_token_secret]}
	    request_token  = OAuth::RequestToken.from_hash(consumer, hash)
	    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_token])
	    session[:access_token]  = access_token.token
	    session[:access_secret_token] = access_token.secret

	    @client = Dropbox::API::Client.new(:token => session[:access_token], :secret => session[:access_secret_token])
        
        @user = User.new
	    @user.name = @client.account.display_name
	    @user.email = @client.account.email
        
        render 'new'
    
    end

    def new
	   @user = User.new
	end

    def create


		
		@user = User.new(users_params)
		if @user.save
			session[:user_id] = @user.id
			# session[] es un objeto donde tu almacenas las variables de sesion
			# la key :user_id la estoy creando en este mismo momento
			# cookie[] es otro objeto disponible para almacenar cosas 
			# session y cookie siempre estan disponibles en todas las requests
			redirect_to root_path
		else
		    render :new
		end    	
		
	end

	def has_secure_password 
		
	end

private

	def users_params
		params
		  .require(:user)
		  .permit(:name, 
		   :email,
		   :password,
		   :password_confirmation
		  )	   
		
	end	
end
