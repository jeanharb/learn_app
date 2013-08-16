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
		if !current_user.examresults.find_by_exam_id(@exam.id).nil?
			@update = current_user.examresults.find_by_exam_id(@exam.id)
			if @update.finalgrade < @finalscore
				@update.finalgrade = @finalscore
				@update.save
			end
		else
			current_user.examresults.create!(exam_id: @exam.id, finalgrade: @finalscore)
		end
		if params.has_key?(:program)
			@program = Program.find_by_id(params[:program])
			redirect_to course_path(@course, :program => params[:program])
		else
			redirect_to course_path(@course)
		end
	end
end
