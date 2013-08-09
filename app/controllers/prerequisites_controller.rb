class PrerequisitesController < ApplicationController
	before_filter :signed_in_user
	before_filter :correct_user

	def create
		if !params.has_key?(:delete)
			@topcourse = params[:course]
			@program = Program.find_by_id(params[:program])
			@topcourse.each do |course, prereqs|
				@rightcourse = Course.find_by_id(course)
				prereqs.each do |prer|
					@rightprer = Course.find_by_id(prer)
					if !@program.isprerequisite?(@rightcourse, @rightprer)
						@program.makeprerequisite!(@rightcourse, @rightprer)
					end
				end
			end
			redirect_to program_path(@program)
		else
			@topcourse = params[:course]
			@program = Program.find_by_id(params[:program])
			@topcourse.each do |course, prereqs|
				@rightcourse = Course.find_by_id(course)
				prereqs.each do |prer|
					@rightprer = Course.find_by_id(prer)
					if @program.isprerequisite?(@rightcourse, @rightprer)
						@program.removeprerequisite!(@rightcourse, @rightprer)
					end
				end
			end
			redirect_to program_path(@program)
		end
	end

	private

		def signed_in_user
			redirect_to signin_url, notice: "Please sign in." unless signed_in?
		end

		def correct_user
			@user = User.find(Program.find(params[:program]).user_id)
			redirect_to(root_path) unless current_user?(@user)
		end
end
