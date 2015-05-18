class User < ActiveRecord::Base
	has_secure_password 
	# esto genera un metodo authenticate que comprueba la password

	# llama a set_default_role después de que el objeto es creado
	# en memoria solo si el objeto user no existe en la db

	after_initialize :set_default_role #, if: => :new_record?
	# aqui arriba tenemos una callback a la que le hemos pasado una condicion 'if'

    # asignamos un usuario por defecto 'consumer'    
    def set_default_role
    	unless self.role
    		self.role = :consumer
    		self.token = :null
    		self.secret = :null
    	end	
    	
    end
end
