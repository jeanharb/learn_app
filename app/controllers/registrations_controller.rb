class RegistrationsController < ApplicationController
	before_filter :signed_in_user
	
	def create
		@program = Program.find_by_id(params[:registration][:takenprog_id])
		current_user.register!(@program)
		redirect_to program_path(@program)
	end

	def destroy
		@program = Program.find_by_id(params[:registration][:takenprog_id])
		current_user.unregister!(@program)
		redirect_to program_path(@program)
	end
end
