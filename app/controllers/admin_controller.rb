class AdminController < ApplicationController
	before_filter :admin_user, only: :database

	def database
	end

	private
    	def admin_user
    		redirect_to(root_path) unless current_user.admin?
    	end
end
