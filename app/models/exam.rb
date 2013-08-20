class Exam < ActiveRecord::Base
  attr_accessible :name, :grade
  has_many :questions, dependent: :destroy
  has_many :reverse_examresults, foreign_key: "exam_id", class_name: "Examresult", dependent: :destroy
  belongs_to :course
  acts_as_list scope: :course

  validates :name, presence: true, :length => { :minimum => 2 }
  validates :course_id, presence: true
  validates :grade, presence: true, :numericality => {:only_integer => true}
end
