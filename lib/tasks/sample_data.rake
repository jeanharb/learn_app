namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		make_users
		make_courses
		make_programs
		make_relationships
	end
end
def make_users
	admin = User.create!(	name: "Jean Harb",
							email: "jharb3@gmail.com",
							password: "jeanharb",
							password_confirmation: "jeanharb")
	admin.toggle!(:admin)
	second = User.create!(	name: "Mathieu Harb",
							email: "jharb31@gmail.com",
							password: "jeanharb",
							password_confirmation: "jeanharb")
end

def make_courses
	jean = User.find_by_id("1")
	math = User.find_by_id("2")
	jean.courses.create!(title: "Finance 101",
						 description: "NOTHING")
	math.courses.create!(title: "Biology 101",
						 description: "SOMETHING")
end

def make_programs
	jean = User.find_by_id("1")
	math = User.find_by_id("2")
	jean.programs.create!(title: "Bachelor's in Finance",
						  description: "LEARN")
	math.programs.create!(title: "Bachelor's in Biology",
						  description: "LEARN SOMETHING")
end

def make_relationships
	finP = Program.find_by_id("1")
	bioP = Program.find_by_id("2")
	finC = Course.find_by_id("1")
	bioC = Course.find_by_id("2")
	finP.takeclass!(finC)
	finP.takeclass!(bioC)
	bioP.takeclass!(bioC)
end

