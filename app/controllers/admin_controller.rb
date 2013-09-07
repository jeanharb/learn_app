class AdminController < ApplicationController
	before_filter :admin_user, only: [:database, :addcategory]

	def database
		@users = User.all
		@cat = Category.new
		@categories = Category.all
	end

	def addcategory
	end

	private
    	def admin_user
    		redirect_to(root_path) unless current_user.admin?
    	end
end
