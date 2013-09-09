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
			@program.setup_prereqs
			redirect_to edit_program_path(@program)
		else
			@program.setup_prereqs
			redirect_to edit_program_path(@program)
		end
	end

	private
		def correct_user_rel
			@user = User.find(Program.find(params[:program]).user_id)
			redirect_to(root_path) unless current_user?(@user)
		end

end
