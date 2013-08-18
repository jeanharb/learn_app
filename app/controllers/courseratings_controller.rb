class CourseratingsController < ApplicationController
	def create
		@course = Course.find(params[:courserating][:id])
		if params[:courserating][:rating]
			@rating = params[:courserating][:rating]
			@findrate = Courserating.find_by_user_id_and_course_id(current_user.id, @course.id)
			if @findrate
				@findrate.update_attribute(:rating, @rating)
				average(@course)
			else
				current_user.courseratings.create!(:course_id => @course.id, :rating => @rating)
				average(@course)
			end
			redirect_to course_path(@course)
		end
		if params[:courserating][:review_title]
			@review_content = params[:courserating][:review_content]
			@review_title = params[:courserating][:review_title]
			@findrate = Courserating.find_by_user_id_and_course_id(current_user.id, @course.id)
			if @findrate
				@findrate.update_attributes(:review_content => @review_content, :review_title => @review_title)
			else
				current_user.courseratings.create!(course_id: @course.id, review_title: @review_title, review_content: @review_content)
			end
			redirect_to course_path(@course)
		end
	end

	def average(course)
		@course_ratings = Courserating.where("course_id = ?", course.id)
		@num_rates = 0
		@total_rate = 0
		@course_ratings.each do |r|
			if !r.rating.nil?
				@num_rates += 1
				@total_rate += r.rating
			end
		end
		if @total_rate != 0
			@averagerating = ((((@total_rate.to_f/@num_rates.to_f)*10).to_f.ceil).to_f/10)
			course.update_attributes(:average_rating => @averagerating, :num_rating => @num_rates)
		end
	end
end
