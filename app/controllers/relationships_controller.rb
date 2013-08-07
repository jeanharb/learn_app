class RelationshipsController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user_rel

	def create
		@program = Program.find(params[:program])
		if params.has_key?(:course)
			@courses = params[:course]
			@courses.each do |course|
				@class = Course.find(course.first)
				if !@program.takingclass?(@class)
					@program.takeclass!(@class)
					current_user.removefromcart!(@class)
				end
			end
			redirect_to program_path(@program)
		else
			redirect_to program_path(@program)
		end
	end

	def destroy
		@course = Relationship.find(params[:id]).course
		current_user.removefromcart!(@course)
		redirect_to course_path(@course)
	end

	private
		def correct_user_rel
			@user = User.find(Program.find(params[:program]).user_id)
			redirect_to(root_path) unless current_user?(@user)
		end

end