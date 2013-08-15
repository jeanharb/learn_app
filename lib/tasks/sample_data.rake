namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_exams
		make_questions
		make_answers
	end
end


def make_exams
	course = Course.find_by_id("1")
	exam = course.exams.create!(name: "Math exam")
end

def make_questions
	exam = Exam.find_by_id("1")
	question = exam.questions.create!(name: "1+1 =")
end

def make_answers
	question = Question.find_by_id("1")
	answer1 = question.answers.create!(name: "2", goodanswer: "true")
	answer2 = question.answers.create!(name: "3", goodanswer: "false")
end
