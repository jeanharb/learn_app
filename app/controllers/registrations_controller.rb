class RegistrationsController < ApplicationController
	before_filter :signed_in_user
	
	def create
		@program = Program.find_by_id(params[:registration][:takenprog_id])
		current_user.register!(@program)
		countprogstudents(@program)
		redirect_to :back
	end

	def destroy
		@program = Program.find_by_id(params[:registration][:takenprog_id])
		current_user.unregister!(@program)
		countprogstudents(@program)
		redirect_to :back
	end
end
