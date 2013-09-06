class ExamresultsController < ApplicationController
	def create
		@exam = Exam.find_by_id(params[:id])
		@answers = params[:question]
		@finalscore1 = 0
		@num_ques = 0
		@random = []
		@course = Course.find_by_id(@exam.course_id)
		@answers.each do |question|
			@thequestion = Question.find_by_id(question[0])
			@theanswer = Answer.find_by_id(question[1])
			if @theanswer.goodanswer == true
				@finalscore1 += 1
				@random << @theanswer.id
			end
			@num_ques += 1
		end
		@finalscore = ((@finalscore1.to_f/@num_ques.to_f)*100).ceil
		@score_needed = @exam.grade
		if @finalscore >= @score_needed
			@passed = "true"
		else
			@passed = "false"
		end
		if !current_user.examresults.find_by_exam_id(@exam.id).nil?
			@update = current_user.examresults.find_by_exam_id(@exam.id)
			if @update.finalgrade <= @finalscore
				@update.finalgrade = @finalscore
				@update.passed = @passed
				@update.save
			end
		else
			current_user.examresults.create!(exam_id: @exam.id, finalgrade: @finalscore, :passed => @passed)
		end
		@allexams = @course.exams
		@counting = 0
		@allexams.each do |exam|
			@examresults = Examresult.where("user_id = ?", current_user).where("exam_id = ?", exam.id).where("passed = ?", "true")
			if @examresults.exists?
				@counting += 1
			end
		end
		@completedcourse = 0
		if @allexams.count == @counting
			@completed = Completecourse.where("user_id = ?", current_user).where("course_id = ?", @course.id)
			if !@completed.exists?
				current_user.finishcourse!(@course)
				@completedcourse = 1
			else
				@finished = Completecourse.find_by_user_id_and_course_id(current_user.id, @course.id)
				@finished.passed = "true"
				@finished.save
				@completedcourse = 1
			end
		else
			@completed = Completecourse.where("user_id = ?", current_user).where("course_id = ?", @course.id)
			if !@completed.exists?
				current_user.failedcourse!(@course)
			end
		end
		if params.has_key?(:program)
			@program = Program.find_by_id(params[:program])
			if @completedcourse == 1
				redirect_to prereq_tree_program_path(@program)
			else
				redirect_to course_path(@course, :program => params[:program])
			end
		else
			redirect_to course_path(@course)
		end
	end
end
