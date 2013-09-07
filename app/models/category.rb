class Category < ActiveRecord::Base
  attr_accessible :image, :title, :imagetype

  scope :order_by, lambda { |o| {:order => o} } 
end
