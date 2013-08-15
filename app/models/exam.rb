class Exam < ActiveRecord::Base
  attr_accessible :name, :course_id, :grade
  has_many :questions, dependent: :destroy
  has_many :reverse_examresults, foreign_key: "exam_id", class_name: "Examresult", dependent: :destroy
  belongs_to :course

  validates :name, presence: true
  validates :course_id, presence: true
  validates :grade, presence: true
end
