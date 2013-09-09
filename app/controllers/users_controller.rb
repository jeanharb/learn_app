class UsersController < ApplicationController
  before_filter :admin_user, only: :destroy
  before_filter :right_user, only: [:edit, :update]

  def new
  	@user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      sign_in @user
      redirect_to current_user
    else
      render 'edit'
    end
  end

  def show
  	@user = User.find(params[:id])
    @programs = @user.takenprogs
    @courses = @user.takencourses
  end

  def cart
    @user = current_user
    @cart = @user.coursefollows.all
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
      redirect_to root_path unless is_admin?
    end

    def right_user
      @right_user = User.find(params[:id])
      redirect_to root_path unless current_user?(@right_user)
    end
    
end
