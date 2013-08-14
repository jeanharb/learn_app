class Registration < ActiveRecord::Base
  attr_accessible :takenprog_id

  belongs_to :student, class_name: "User"
  belongs_to :takenprog, class_name: "Program"

  validates :student_id, presence: true
  validates :takenprog_id, presence: true
end
