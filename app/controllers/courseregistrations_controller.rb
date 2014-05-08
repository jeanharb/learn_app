class CourseregistrationsController < ApplicationController
	before_filter :signed_in_user
	
	def create
		@course = Course.find_by_id(params[:courseregistration][:takencourse_id])
		current_user.courseregister!(@course)
		countcoursestudents(@course)
		@exams = @course.exams
		@notes = @course.notes
		render :template => "courses/toggle_course", :locals => {:@notes => @notes, :@exams => @exams, :@see_exam => true}
	end

	def destroy
		@course = Course.find_by_id(params[:courseregistration][:takencourse_id])
		current_user.courseunregister!(@course)
		countcoursestudents(@course)
		@exams = @course.exams
		@notes = @course.notes
		render :template => "courses/toggle_course", :locals => {:@notes => @notes, :@exams => @exams, :@see_exam => false}
	end
end
