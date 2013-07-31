class Relationship < ActiveRecord::Base
  attr_accessible :program_id, :course_id
  belongs_to :course, class_name: "Course"
  belongs_to :program, class_name: "Program"

  validates :program_id, presence: true
  validates :course_id, presence: true
end
