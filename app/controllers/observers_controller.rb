class ObserversController < ApplicationController

	def new

		@observer = Observer.new
		
	end
end
