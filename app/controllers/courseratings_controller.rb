class CourseratingsController < ApplicationController
	def create
		@course = Course.find(params[:courserating][:id])
		if params[:courserating][:rating]
			@rating = params[:courserating][:rating]
			@findrate = Courserating.find_by_user_id_and_course_id(current_user.id, @course.id)
			if @findrate
				@findrate.update_attribute(:rating, @rating)
			else
				@save = current_user.courseratings.create!(course_id: @course.id, rating: @rating)
			end
			redirect_to course_path(@course)
		end
		if params[:courserating][:review]
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
end
