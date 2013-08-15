class QuestionsController < ApplicationController
	def create
		if !params.has_key?(:exam)
			@course = Course.find_by_id(params[:id])
			@exam = @course.exams.create(name: params[:exam_name], grade: params[:grade_num])
			@question = 1
		else
			@course = Course.find_by_id(params[:id])
			@exam = Exam.find_by_id(params[:exam])
			@question = params[:question_num]
		end
		@exam_question = @exam.questions.create!(name: params[:question][:name])
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
					@exam_question.answers.create!(:name => @name, :goodanswer => @goodanswer)
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
end
