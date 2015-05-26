class ObserversController < ApplicationController

	def new
		@observer = Observer.new
		render observer_path
		
	end

	def create

		
		
	end



end
