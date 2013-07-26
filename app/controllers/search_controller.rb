class SearchController < ApplicationController
	before_filter :signed_in_user, only: [:index]

	def index
		@usersearch = User.find_by_name(params[:fname])
	end

	private
		def signed_in_user
			redirect_to root_path unless signed_in?
		end
end