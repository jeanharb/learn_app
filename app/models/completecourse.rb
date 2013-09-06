class Completecourse < ActiveRecord::Base
  attr_accessible :course_id, :passed
  belongs_to :user
  belongs_to :course

  validates :user_id, presence: true
  validates :course_id, presence: true
  validates :passed, presence: true
end
