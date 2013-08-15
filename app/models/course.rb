class Course < ActiveRecord::Base
  attr_accessible :description, :title
  belongs_to :user
  has_many :notes, dependent: :destroy
  has_many :reverse_carts, foreign_key: "coursefollow_id", class_name: "Cart", dependent: :destroy
  has_many :followers, through: :reverse_carts, source: :follower
  has_many :reverse_relationships, foreign_key: "course_id", class_name: "Relationship", dependent: :destroy
  has_many :programs, through: :reverse_relationships, source: :program
  has_many :reverse_prerequisites, foreign_key: "required_id", class_name: "Prerequisite", dependent: :destroy
  has_many :wantpros, through: :reverse_prerequisites, source: :wantpro
  has_many :wants, through: :reverse_prerequisites, source: :want
  has_many :courstudents, through: :reverse_courseregistrations, source: :courstudent
  has_many :reverse_courseregistrations, foreign_key: "takencourse_id", class_name: "Courseregistration", dependent: :destroy
  has_many :exams, dependent: :destroy
  has_many :reverse_exams, foreign_key: "testcourse_id", class_name: "Exam", dependent: :destroy

  validates :user_id, presence: true
  validates :description, presence: true
  validates :title, presence: true
end
