class CoursesController < ApplicationController
	before_filter :signed_in_user, only: [:create, :edit, :update]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :course_des, only: :destroy
	
	def new
		@user = User.find_by_remember_token(cookies[:remember_token])
    	@course = current_user.courses.build if signed_in?
	end

	def create
        @course = current_user.courses.build(params[:course])
        if @course.save
          redirect_to course_path(@course)
        else
          render 'new'
        end
	end

	def index
		if is_admin?
			store_location
		end
		@courses = Course.all
	end

	def edit
		@course = Course.find(params[:id])
	end

	def show
		@course = Course.find(params[:id])
		@rating = Courserating.new
		@review = Courserating.new
		@hasreview = Courserating.where("course_id = ?", @course.id).where("user_id = ?", current_user.id).where("review_title IS NOT NULL")
		@courseratings = Courserating.where("course_id = ?", @course.id).where("rating IS NOT NULL")
		@coursereviews = Courserating.where("course_id = ?", @course.id).where("review_title IS NOT NULL")
		@averagerating = "0"
		if @courseratings.any?
			if @course.average_rating != 0
				@num_rates = @course.num_rating
				@averagerating = @course.average_rating
				@good_starwidth = (@averagerating.to_f/0.05).to_f.to_s + "%"
				@anti_starwidth = (((1-(@averagerating.to_f/5))*100).to_f).to_f.to_s + "%"
			end
		end
    	@notes = @course.notes
    	@note = @course.notes.build if signed_in?
    	@program_in = false
    	if params.has_key?(:program)
    		@courses = []
    		@program = Program.find(params[:program])
    		@program_in = true
    		@prereqs = Prerequisite.where("want_id = ?", @course.id).where("wantpro_id = ?", @program.id)
    		@prereqs.each do |prereq|
    			@course_need = Course.find_by_id(prereq.required_id)
    			@courses.append(@course_need)
    		end
    	end
    	if @program_in
    		@see_exam = current_user.courseregistered?(@course) || current_user.registered?(@program)
    	else
    		@see_exam = current_user.courseregistered?(@course)
    	end
    	@exams = @course.exams
	end

	def update
		@course = Course.find(params[:id])
		if @course.update_attributes(params[:course])
			redirect_to course_path(@course)
		else
			render 'edit'
		end
	end

	def destroy
		@course = Course.find(params[:id])
		@course.destroy
		redirect_to creations_path
	end

	def classincart?(course)
    	carts.find_by(course.id)
  	end

	private

		def course_des
			redirect_to root_path unless creator?
		end

		def is_admin
			redirect_to root_path unless is_admin?
		end

		def signed_in_user
			redirect_to signin_url, notice: "Please sign in." unless signed_in?
		end

		def correct_user
			@user = User.find(Course.find(params[:id]).user_id)
			redirect_to(root_path) unless current_user?(@user)
		end
end
