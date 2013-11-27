class AdminController < ApplicationController
	before_filter :admin_user, only: [:database, :addcategory, :add_number]

	def database
		@users = User.all
		@numbs = NumberUsers.all
		@ids = @numbs.map{|h| h.num_users }
		@max_num = @ids.map.max.to_f/4
		@num_array = Array.new(5){ |i| (i*@max_num).to_i.to_s }
		@names = @numbs.map{|h| h.date }
		@cat = Category.new
		@categories = Category.all
	end

	def add_number
		NumberUsers.add_number
		redirect_to database_path
	end

	def addcategory
	end

	private
    	def admin_user
    		redirect_to(root_path) unless current_user.admin?
    	end
end
