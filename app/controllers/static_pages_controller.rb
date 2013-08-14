class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		@user = current_user
  	end
  end

  def about
  end

  def help
  end
end
