class RegistrationsController < ApplicationController
	before_filter :signed_in_user
	
	def create
		@program = Program.find_by_id(params[:registration][:takenprog_id])
		current_user.register!(@program)
		countprogstudents(@program)
		if (params[:registration][:in_course]=="0")
			redirect_to :back
		else
			@course = Course.find_by_id(params[:registration][:in_course])
			@exams = @course.exams
			@notes = @course.notes
			render :template => "registrations/toggle_course", :locals => {:@notes => @notes, :@exams => @exams, :@see_exam => true}
		end
	end

	def destroy
		@program = Program.find_by_id(params[:registration][:takenprog_id])
		current_user.unregister!(@program)
		countprogstudents(@program)
		redirect_to :back
	end
end
