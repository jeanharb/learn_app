namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Jean Harb",
							 email: "jharb3@gmail.com",
							 password: "jeanharb",
							 password_confirmation: "jeanharb")
		admin.toggle!(:admin)
	end
end