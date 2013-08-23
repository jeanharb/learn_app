class Examresult < ActiveRecord::Base
  attr_accessible :exam_id, :finalgrade, :user_id, :passed
  belongs_to :user
  belongs_to :exam

  validates :exam_id, presence: true
  validates :user_id, presence: true
  validates :finalgrade, presence: true
  validates :passed, presence: true
end
