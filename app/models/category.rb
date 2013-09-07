class Category < ActiveRecord::Base
  attr_accessible :image, :title, :imagetype, :numprog, :numcour

  scope :order_by, lambda { |o| {:order => o} } 
end
