class User < ActiveRecord::Base

	has_many :observers

	def self.find_or_create(name, email)

		if exists?(:email => email)
        	user = find_by email: email
        else
            user = create_for(name, email)
        end

        user
		
	end


	def self.create_for(name, email)
		
		user = self.new
		user.name = name
		user.email = email
		user.save

		user

	end

	def set_dropbox_credentials(access)

		self.token = access.token
		self.secret = access.secret
		self.save
		
	end

end
