namespace :db do
	desc "Fill database with sample data"
	task populate: :environment do
		admin = User.create!(name: "Jean Harb",
							 email: "jharb3@gmail.com",
							 password: "jeanharb",
							 password_confirmation: "jeanharb")
		admin.toggle!(:admin)
		1.times do
			content = Base64.encode64(open("app/assets/images/letter2.pdf").to_a.join)
			filename = "letter2.pdf"
			admin.notes.create!(content: content, filename: filename)
		end
	end
end