class Courseregistration < ActiveRecord::Base
  attr_accessible :takencourse_id

  belongs_to :courstudent, class_name: "User"
  belongs_to :takencourse, class_name: "Course"

  validates :courstudent_id, presence: true
  validates :takencourse_id, presence: true
end
