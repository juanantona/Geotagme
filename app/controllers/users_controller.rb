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
        
        if User.exists?(:email => @client.account.email)
	    	@user = User.find_by email: @user.email
	    	@user.token = session[:access_token]
		    @user.secret = session[:access_secret_token]
		    @user.save
        	redirect_to dashboard_path
        else
            create(@client)
        end	
    
    end

    def create(client)
		
		@user = User.new
		@user.name = client.account.display_name
		@user.email = client.account.email
		@user.token = session[:access_token]
		@user.secret = session[:access_secret_token]
		
		if @user.save
			session[:user_id] = @user.id
			@user.save

			redirect_to dashboard_path
		else
		    render '/'
		end    	
		
	end

end
