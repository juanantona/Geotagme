class UsersController < ApplicationController

	def authorize
	   
	    consumer = Dropbox::API::OAuth.consumer(:authorize)
	    request_token = consumer.get_request_token
	    session[:request_token] = request_token.token
	    session[:request_token_secret] = request_token.secret
	    redirect_to request_token.authorize_url(:oauth_callback => "http://#{request.host_with_port}/dropbox/callback")
    
    end

    def callback
	    
	    access_token = get_access_token
	    
	    client = Dropbox::API::Client.new(:token => access_token.token, :secret => access_token.secret)
        
        @user = User.find_or_create(client.account.display_name, client.account.email)
        @user.set_dropbox_credentials(access_token)
		session[:user_id] = @user.id
			
		redirect_to dashboard_path	
    
    end

    def get_access_token

    	consumer = Dropbox::API::OAuth.consumer(:authorize)
	    hash = { oauth_token: session[:request_token], oauth_token_secret: session[:request_token_secret]}
	    request_token  = OAuth::RequestToken.from_hash(consumer, hash)
	    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_token])
    	
    	access_token
    end
end
