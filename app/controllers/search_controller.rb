class SearchController < ApplicationController
	before_filter :signed_in_user, only: [:index]

	def index
		@course = Course.search do
			fulltext params[:fname]
		end
		@courses = @course.results
		@program = Program.search do
			fulltext params[:fname]
		end
		@programs = @program.results
	end

	private
		def signed_in_user
			redirect_to root_path unless signed_in?
		end
end