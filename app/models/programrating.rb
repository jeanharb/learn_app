class Programrating < ActiveRecord::Base
  attr_accessible :program_id, :rating, :review_content, :review_title
  belongs_to :user
  belongs_to :program

  validates :user_id, presence: true
  validates :program_id, presence: true
  validates :rating, :numericality => {:only_integer => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5}
end
