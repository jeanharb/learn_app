class CategoriesController < ApplicationController
	before_filter :admin_user, only: [:create, :destroy, :edit, :update]
	def create
		@image = Base64.encode64(open(params[:category][:image].tempfile).to_a.join)
		Category.create!(:title => params[:category][:title], :image => @image, :imagetype => params[:category][:image].content_type)
	  	redirect_to database_path
	end

	def update
		@cat = Category.find(params[:id])
		if params[:category].has_key?(:image)
			@image = Base64.encode64(open(params[:category][:image].tempfile).to_a.join)
			@cat.update_attributes(:title => params[:category][:title], :image => @image, :imagetype => params[:category][:image].content_type)
		else
			@cat.update_attributes(:title => params[:category][:title])
		end
		redirect_to database_path
	end

	def edit
		@cat = Category.find(params[:id])
	end

	def destroy
    	Category.find(params[:id]).destroy
    	redirect_to database_path
  	end

  	def show
  		@cat = Category.find(params[:id])
  		@programs_1 = Program.where("category = ?", @cat.id)
  		@courses_1 = Course.where("category = ?", @cat.id)
  		@prog_size = @programs_1.size
  		@cour_size = @courses_1.size
  		@programs = @programs_1.first(4)
  		@courses = @courses_1.first(4)
  	end

	private
    	def admin_user
    		redirect_to(root_path) unless current_user.admin?
    	end
end
