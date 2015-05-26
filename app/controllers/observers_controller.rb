class ObserversController < ApplicationController

	def new
		@observer = Observer.new
		render observer_path
		
	end

	def create

		@observer = Observer.new(observer_params)
		@observer.user_id = current_user.id

		if @observer.save
			redirect_to dashboard_path
		else
			redirect_to observer_path
		end	
		
	end

	def has_secure_password 
		
	end

	private

	def observer_params

		params.require(:observer)
		  .permit(:name, 
		   :email,
		   :password,
		   :password_confirmation,
		   :start_temp_permissions,
		   :terminate_temp_permissions,
		   :user_id, 
		  )	
	end

end
