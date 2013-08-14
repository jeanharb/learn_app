class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@user = current_user
  		@programs = @user.takenprogs
  		@courses = @user.takencourses
  	end
  end

  def about
  end

  def help
  end
end
