class Courserating < ActiveRecord::Base
  attr_accessible :course_id, :rating, :review_content, :review_title
  belongs_to :user
  belongs_to :course

  validates :user_id, presence: true
  validates :course_id, presence: true
  validates :rating, :numericality => {:only_integer => true, :greater_than_or_equal_to => 1, :less_than_or_equal_to => 5}, :allow_nil => true
  validates :review_title, :length => { :minimum => 2 , :maximum => 60 }, :allow_nil => true
  validates :review_content, :length => { :minimum => 2 }, :allow_nil => true
end
