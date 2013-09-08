class CourseregistrationsController < ApplicationController
	before_filter :signed_in_user
	
	def create
		@course = Course.find_by_id(params[:courseregistration][:takencourse_id])
		current_user.courseregister!(@course)
		countcoursestudents(@course)
		redirect_to course_path(@course)
	end

	def destroy
		@course = Course.find_by_id(params[:courseregistration][:takencourse_id])
		current_user.courseunregister!(@course)
		countcoursestudents(@course)
		redirect_to course_path(@course)
	end
end
