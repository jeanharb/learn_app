class ExamsController < ApplicationController
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
	end

	def destroy
	end
end
