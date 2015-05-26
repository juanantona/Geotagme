class SiteController < ApplicationController

	def home
		@observer = Observer.new
		
	end
end
