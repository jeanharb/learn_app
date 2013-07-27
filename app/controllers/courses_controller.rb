class CoursesController < ApplicationController
	before_filter :signed_in_user, only: [:edit, :update]
	before_filter :correct_user, only: [:edit, :update]
	
	def new
		@user = User.find_by_remember_token(cookies[:remember_token])
    	@course = current_user.courses.build if signed_in?
	end

	def create
        @course = current_user.courses.build(params[:course])
        if @course.save
          flash[:success] = "Course Created!"
          redirect_to user_path(current_user)
        else
          render 'new'
        end
	end

	def index
		@courses = Course.all
	end

	def edit
		@course = Course.find(params[:id])
	end

	def show
		@course = Course.find(params[:id])
	end

	def update
		@course = Course.find(params[:id])
		if @course.update_attributes(params[:course])
			flash[:success] = "Course Updated"
			redirect_to creations_path
		else
			render 'edit'
		end
	end

	def destroy
	end

	def creations
		@courses = current_user.courses.all
	end

	private
		def signed_in_user
			redirect_to signin_url, notice: "Please sign in." unless signed_in?
		end

		def correct_user
			@user = User.find(Course.find(params[:id]).user_id)
			redirect_to(root_path) unless current_user?(@user)
		end
end
