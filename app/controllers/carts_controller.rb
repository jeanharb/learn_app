class CartsController < ApplicationController
	before_filter :signed_in_user
	
	def create
		@course = Course.find_by_id(params[:cart][:coursefollow_id])
		current_user.putincart(@course)
		render :toggle
	end

	def destroy
		@course = Cart.find(params[:id]).coursefollow
		current_user.removefromcart!(@course)
		if !params[:cart].nil?
		  redirect_to '/cart'
		else
		  render :toggle
		end
	end
end
