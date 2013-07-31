class UsersController < ApplicationController
  before_filter :admin_user, only: :destroy

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
  		sign_in @user
  		flash[:success] = "Welcome to Learnocracy!"
  		redirect_to @user
  	else
  		render 'new'
  	end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to database_path
  end

  def creations
    @courses = current_user.courses.all
    @programs = current_user.programs.all
  end

  private

    def admin_user
      redirect_to(root_path) unless is_admin?
    end
    
end
