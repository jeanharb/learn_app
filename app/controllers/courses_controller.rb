class CoursesController < ApplicationController
	before_filter :signed_in_user, only: [:create, :edit, :update]
	before_filter :correct_user, only: [:edit, :update]
	before_filter :course_des, only: :destroy
	before_filter :program_creator, only: [:listorder_up, :listorder_down]
	
	def new
		@user = User.find_by_remember_token(cookies[:remember_token])
    	@course = current_user.courses.build if signed_in?
	end

	def create
        @course = current_user.courses.build(params[:course])
        if @course.save
          countcat(params[:course][:category])
          redirect_to course_path(@course)
        else
          render 'new'
        end
	end

	def listorder_up
	  @program = Program.find(params[:program])
	  @relationship = Relationship.find_by_program_id_and_course_id(params[:program], params[:course])
	  @relationship.move_higher
	  redirect_to edit_program_path(@program)
	end

	def listorder_down
	  @program = Program.find(params[:program])
	  @relationship = Relationship.find_by_program_id_and_course_id(params[:program], params[:course])
	  @relationship.move_lower
	  redirect_to edit_program_path(@program)
	end

	def index
		@courses = Course.order("rating_algo DESC").all
	end

	def edit
		@course = Course.find(params[:id])
		@course_id = @course.id
		@exams = @course.exams
		@notes = @course.notes
    	@note = @course.notes.build
    	@new_note = @course.notes.build
    	@note_vid = @course.notes.build
	end

	def newexam
		@course = Course.find(params[:id])
		if params.has_key?(:exam)
			@exam = Exam.find_by_id(params[:exam])
			@exam_num = params[:exam]
			@question_num = params[:question_num].to_i + 1
		else
			@question_num = 1
			@exam = Exam.new
		end
		@questions = Question.new
		@answer = Answer.new
	end

	def show
		@course = Course.find(params[:id])
		@notpassed = "yes"
		@passing = Completecourse.where("user_id = ?", current_user).where("course_id = ?", @course.id)
		if @passing.exists?
			@passingyes = Completecourse.find_by_user_id_and_course_id(current_user.id, @course.id)
			if @passingyes.passed == "true"
				@notpassed = "no"
			end
		end
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
			countcat(params[:course][:category])
			render "course_edit_js"
		else
			render "course_edit_js"
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

  	def passcourse
  		@course = Course.find(params[:id])
  		if !@course.exams.any?
  			if !Completecourse.where("user_id = ?", current_user.id).where("course_id = ?", @course.id).exists?
  				current_user.finishcourse!(@course)
  				countpassedcourse(@course)
  				if params.has_key?(:program)
		  			@program = Program.find_by_id(params[:program])
		  			current_user.countprogressprog(@program, current_user)
		  			countpassedprog(@program)
		  		end
  			end
  		end
  		if params.has_key?(:program)
  			@program = Program.find_by_id(params[:program])
  			redirect_to prereq_tree_program_path(@program)
  		else
  			redirect_to course_path(@course)
  		end
  	end

	private

		def countcat(cat)
			@num = Course.where("category = ?", cat)
			@count = @num.count
			@cat = Category.find(cat)
			@cat.numcour = @count
			@cat.save
		end

		def program_creator
			@user = User.find(Program.find(params[:program]).user_id)
			redirect_to root_path unless current_user?(@user)
		end

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
