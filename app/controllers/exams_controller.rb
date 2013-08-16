class ExamsController < ApplicationController
	before_filter :course_crea, only: [:create, :new]
	before_filter :destroyer, only: :destroy
	before_filter :registered, only: :show
	def new
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
		@exam = Exam.find_by_id(params[:id])
		@course = Course.find_by_id(@exam.course_id)
		@questions = Question.where("exam_id = ?", @exam.id)
	end
	
	def create
		if !params.has_key?(:exam)
			@course = Course.find_by_id(params[:id])
			@question = 1
			@exam_name = params[:exam_name]
			@exam_grade = params[:grade_num].to_f.to_i.to_s
			@question_name = params[:question][:name]
			@answer_names = []
			@answers_question = params[:question]
			@answers_question.each do |key, value|
				if key == "answers_attributes"
					@answers = value
				end
			end
			@answers.each_with_index do |allanswers, wawa|
				length = allanswers.length
				allanswers.each_with_index do |eachanswer, i|
					eachanswer.each do |key|
						if key == "name"
							@word = eachanswer[eachanswer.index(key) + 1].to_s
							@number = (wawa+1)
							@answer_pair = []
							@answer_pair << @word
							@answer_pair << @number
							@answer_names << @answer_pair
						end
					end
				end
			end
			@errors = []
			@error_count = 0
			if @exam_name.length < 2
				@errors << "Exam name must be at least 2 letters long."
				@error_count += 1
			end
			if @exam_name == ""
				@errors << "Exam name cannot be empty."
				@error_count += 1
			end
			if @exam_grade == ""
				@errors << "Grade cannot be empty."
				@error_count += 1
			else
				if @exam_grade.to_f == 0.0 and @exam_grade != '0'
					@errors << "Grade must be a number."
					@error_count += 1
				end
			end
			if @exam_grade.to_i > 100 or @exam_grade.to_i <= 0
				@errors << "Grade must be between 0 and 100."
				@error_count += 1
			end
			if @question_name.length < 2
				@errors << "Question name must be at least 2 letters long."
				@error_count += 1
			end
			if @question_name == ""
				@errors << "Question name cannot be empty."
				@error_count += 1
			end
			@answer_names.each do |answerp|
				@answer_word = answerp[0]
				@answer_num = answerp[1]
				if @answer_word == ""
					@errors << "Answer #{@answer_num} cannot be empty."
					@error_count += 1
				end
			end
			if @error_count > 0
				return redirect_to newexam_path(:answer1 => @answer_names[0][0], :answer2 => @answer_names[1][0], :question_name => params[:question][:name], :question_num => params[:question_num], :id => params[:id], :errors => @errors, :exam_name => params[:exam_name], :grade_num => params[:grade_num])
			end
			@exam = @course.exams.create(name: params[:exam_name], grade: @exam_grade.to_i)
		else
			@course = Course.find_by_id(params[:id])
			@exam = Exam.find_by_id(params[:exam])
			@question = params[:question_num]
			@question_name = params[:question][:name]
			@answer_names = []
			@answers_question = params[:question]
			@answers_question.each do |key, value|
				if key == "answers_attributes"
					@answers = value
				end
			end
			@answers.each_with_index do |allanswers, wawa|
				length = allanswers.length
				allanswers.each_with_index do |eachanswer, i|
					eachanswer.each do |key|
						if key == "name"
							@word = eachanswer[eachanswer.index(key) + 1].to_s
							@number = (wawa+1)
							@answer_pair = []
							@answer_pair << @word
							@answer_pair << @number
							@answer_names << @answer_pair
						end
					end
				end
			end
			@errors = []
			@error_count = 0
			if @question_name.length < 2
				@errors << "Question name must be at least 2 letters long."
				@error_count += 1
			end
			if @question_name == ""
				@errors << "Question name cannot be empty"
				@error_count += 1
			end
			@answer_names.each do |answerp|
				@answer_word = answerp[0]
				@answer_num = answerp[1]
				if @answer_word == ""
					@errors << "Answer #{@answer_num} cannot be empty."
					@error_count += 1
				end
			end
			if @error_count > 0
				return redirect_to newexam_path(:answer1 => @answer_names[0][0], :answer2 => @answer_names[1][0], :question_name => params[:question][:name], :question_num => params[:question_num], :id => params[:id], :errors => @errors, :exam => params[:exam])
			end
		end
		@exam_question = @exam.questions.create(name: params[:question][:name])
		@answers_question = params[:question]
		@answers_question.each do |key, value|
			if key == "answers_attributes"
				@answers = value
			end
		end
		@answers.each do |allanswers|
			length = allanswers.length
			allanswers.each_with_index do |eachanswer, i|
				@goodanswer = 'false'
				eachanswer.each do |key|
					if key == "name"
						@name = eachanswer[eachanswer.index(key) + 1].to_s
					end
					if key == "goodanswer"
						@goodanswer = "true"
					end
				end
				if i+1 == length
					@answer = @exam_question.answers.create(:name => @name, :goodanswer => @goodanswer)
				end
			end
		end
		@question = (@question.to_i + 1).to_s
		if params.has_key?(:complete)
			redirect_to course_path(@course)
		else
			redirect_to newexam_path(id: @course.id, exam: @exam.id, question_num: @question)
		end
	end

	def destroy
		@exam = Exam.find(params[:id])
		@course = @exam.course_id
		@exam.destroy
		redirect_to course_path(@course)
	end

	private

		def destroyer
			redirect_to root_path unless destroyer?
		end

		def course_crea
			redirect_to root_path unless examcreator?
		end

		def registered
			redirect_to root_path unless registered_in?
		end
end
