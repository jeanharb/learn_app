class Examresult < ActiveRecord::Base
  attr_accessible :exam_id, :finalgrade, :user_id
  belongs_to :user

  validates :exam_id, presence: true
  validates :user_id, presence: true
  validates :finalgrade, presence: true
end
