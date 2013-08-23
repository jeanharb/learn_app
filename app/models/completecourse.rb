class Completecourse < ActiveRecord::Base
  attr_accessible :course_id, :passed

  validates :user_id, presence: true
  validates :course_id, presence: true
  validates :passed, presence: true
end
