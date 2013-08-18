class Courserating < ActiveRecord::Base
  attr_accessible :course_id, :rating, :review_content, :review_title
  belongs_to :user
  belongs_to :course

  validates :user_id, presence: true
  validates :course_id, presence: true
  validates :rating, presence: true, :numericality => {:only_integer => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 5}
  validates :review_title, presence: true, :length => { :minimum => 2 , :maximum => 60 }
  validates :review_content, presence: true, :length => { :minimum => 2 }
end
