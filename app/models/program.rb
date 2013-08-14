class Program < ActiveRecord::Base
  attr_accessible :description, :title
  belongs_to :user
  has_many :relationships, foreign_key: "program_id", dependent: :destroy
  has_many :courses, through: :relationships, source: :course
  has_many :wants, through: :prerequisites, source: :want
  has_many :required_courses, through: :prerequisites, source: :required
  has_many :prerequisites, foreign_key: "wantpro_id", dependent: :destroy
  has_many :students, through: :reverse_registrations, source: :student
  has_many :reverse_registrations, foreign_key: "takenprog_id", class_name: "Registration", dependent: :destroy

  validates :user_id, presence: true
  validates :description, presence: true
  validates :title, presence: true

  def makeprerequisite!(course1, course2)
    prerequisites.create!(required_id: course2.id, want_id: course1.id)
  end

  def isprerequisite?(course1, course2)
    prerequisites.find_by_required_id_and_want_id(course2.id, course1.id)
  end

  def removeprerequisite!(course1, course2)
    prerequisites.find_by_required_id_and_want_id(course2.id, course1.id).destroy
  end

  def takingclass?(course)
    relationships.find_by_course_id(course.id)
  end

  def takeclass!(course)
    relationships.create!(course_id: course.id)
  end

  def removeclass!(course)
    relationships.find_by_course_id(course.id).destroy!
  end
end
