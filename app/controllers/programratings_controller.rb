class ProgramratingsController < ApplicationController
	def create
		@program = Program.find(params[:programrating][:id])
		if params[:programrating][:rating]
			@rating = params[:programrating][:rating]
			@findrate = Programrating.find_by_user_id_and_program_id(current_user.id, @program.id)
			if @findrate
				@findrate.update_attribute(:rating, @rating)
				average(@program)
			else
				current_user.programratings.create!(:program_id => @program.id, :rating => @rating)
				average(@program)
			end
			redirect_to program_path(@program)
		end
		if params[:programrating][:review_title]
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

	def average(program)
		@program_ratings = Programrating.where("program_id = ?", program.id)
		@num_rates = 0
		@total_rate = 0
		@program_ratings.each do |r|
			if !r.rating.nil?
				@num_rates += 1
				@total_rate += r.rating
			end
		end
		if @total_rate != 0
			@averagerating = ((((@total_rate.to_f/@num_rates.to_f)*10).to_f.ceil).to_f/10)
			program.update_attributes(:average_rating => @averagerating, :num_rating => @num_rates)
		end
	end
end
