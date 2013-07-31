class RelationshipsController < ApplicationController
	before_filter :signed_in_user

	def create
	end

	def destroy
		@course = Relationship.find(params[:id]).course
		current_user.removefromcart!(@course)
		redirect_to course_path(@course)
	end

end
