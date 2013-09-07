class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@user = current_user
  		@categories = Category.all
  	end
  end

  def about
  end

  def help
  end
end
