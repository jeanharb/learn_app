class CoursesController < ApplicationController
	before_filter :signed_in_user
	
	def new
		@user = User.find_by_remember_token(cookies[:remember_token])
    	@course = current_user.courses.build if signed_in?
	end

	def create
        @course = current_user.courses.build(params[:course])
        if @course.save
          flash[:success] = "File Uploaded!"
          redirect_to user_path(current_user)
        else
          render 'new'
        end
	end

	def destroy
	end

	def creations
	end

end
