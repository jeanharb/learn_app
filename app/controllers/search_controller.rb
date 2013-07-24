class SearchController < ApplicationController

	def index
		@usersearch = User.find_by_name(params[:fname])
	end
end