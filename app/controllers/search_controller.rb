class SearchController < ApplicationController
	before_filter :signed_in_user

	def index
		if params.has_key?(:fname)
			@search_length = params[:fname].split.length
			@search = params[:fname]
			search = params[:fname]
			search_length = params[:fname].split.length
			@course = Course.find(:all, :conditions => [(['lower(title) LIKE ?'] * search_length).join(' AND ')] + search.downcase.split.map { |title| "%#{title}%" })
			@program = Program.find(:all, :conditions => [(['lower(title) LIKE ?'] * search_length).join(' AND ')] + search.downcase.split.map { |title| "%#{title}%" })
		else
			redirect_to search_path(:fname => "")
		end
	end

	private
		def signed_in_user
			redirect_to root_path unless signed_in?
		end
end