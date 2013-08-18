class ProgramratingsController < ApplicationController
	def create
		@program = Program.find(params[:programrating][:id])
		if params[:programrating][:rating]
			@rating = params[:programrating][:rating]
			@findrate = Programrating.find_by_user_id_and_program_id(current_user.id, @program.id)
			if @findrate
				@findrate.update_attribute(:rating, @rating)
			else
				current_user.programratings.create!(program_id: @program.id, rating: @rating)
			end
			redirect_to program_path(@program)
		end
		if params[:programrating][:review]
			@review_content = params[:programrating][:review_content]
			@review_title = params[:programrating][:review_title]
			@findrate = Programrating.find_by_user_id_and_program_id(current_user.id, @program.id)
			if @findrate
				@findrate.update_attributes(:review_content => @review_content, :review_title => @review_title)
			else
				current_user.programratings.create!(program_id: @program.id, review_title: @review_title, review_content: @review_content)
			end
			redirect_to program_path(@program)
		end
	end
end
