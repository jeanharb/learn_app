class Program < ActiveRecord::Base
  attr_accessible :description, :title, :average_rating, :num_rating, :rating_algo
  belongs_to :user
  has_many :relationships, foreign_key: "program_id", dependent: :destroy
  has_many :courses, order: :position, through: :relationships, source: :course
  has_many :wants, through: :prerequisites, source: :want
  has_many :required_courses, through: :prerequisites, source: :required
  has_many :prerequisites, foreign_key: "wantpro_id", dependent: :destroy
  has_many :students, through: :reverse_registrations, source: :student
  has_many :reverse_registrations, foreign_key: "takenprog_id", class_name: "Registration", dependent: :destroy
  has_many :programratings, dependent: :destroy
  has_many :ratings, through: :programratings, source: :program
  has_many :review_titles, through: :programratings, source: :program
  has_many :review_contents, through: :programratings, source: :program

  validates :user_id, presence: true
  validates :description, presence: true
  validates :title, presence: true
  validates :average_rating, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 5}
  validates :rating_algo, :numericality => {:integer => true}

  def makeprerequisite!(course1, course2)
    prerequisites.create!(required_id: course2.id, want_id: course1.id)
  end

  def hasrating?(user)
    programratings.find_by_user_id(user.id)
  end

  def createrating!(user, rating)
    programratings.create!(user_id: user.id, rating: rating)
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
