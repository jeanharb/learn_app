class Course < ActiveRecord::Base
  attr_accessible :description, :title, :average_rating, :num_rating, :rating_algo, :category, :numstudentspass
  belongs_to :user
  has_many :notes, order: :position, dependent: :destroy
  has_many :reverse_carts, foreign_key: "coursefollow_id", class_name: "Cart", dependent: :destroy
  has_many :followers, through: :reverse_carts, source: :follower
  has_many :relationships, dependent: :destroy
  has_many :reverse_relationships, foreign_key: "course_id", class_name: "Relationship", dependent: :destroy
  has_many :programs, through: :reverse_relationships, source: :program
  has_many :reverse_prerequisites, foreign_key: "required_id", class_name: "Prerequisite", dependent: :destroy
  has_many :wantpros, through: :reverse_prerequisites, source: :wantpro
  has_many :wants, through: :reverse_prerequisites, source: :want
  has_many :courstudents, through: :reverse_courseregistrations, source: :courstudent
  has_many :reverse_courseregistrations, foreign_key: "takencourse_id", class_name: "Courseregistration", dependent: :destroy
  has_many :exams, order: :position, dependent: :destroy
  has_many :reverse_exams, foreign_key: "course_id", class_name: "Exam", dependent: :destroy
  has_many :courseratings, dependent: :destroy
  has_many :ratings, through: :courseratings, source: :course
  has_many :review_titles, through: :courseratings, source: :course
  has_many :review_contents, through: :courseratings, source: :course
  has_many :completecourses, dependent: :destroy

  validates :user_id, presence: true
  validates :description, presence: true
  validates :title, presence: true
  validates :average_rating, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 5}
  validates :rating_algo, :numericality => {:integer => true}

  def hasrating?(user)
    courseratings.find_by_user_id(user.id)
  end
end
