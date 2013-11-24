class StaticPagesController < ApplicationController
  def home
    @total = User.all.count
  	if signed_in?
  		@user = current_user
  		@categories = Category.order_by('title ASC').all
    else
      @home_page = true
  	end
  end

  def about
  end

  def help
  end
end
