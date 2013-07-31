class Course < ActiveRecord::Base
  attr_accessible :description, :title
  belongs_to :user
  has_many :notes, dependent: :destroy
  has_many :reverse_relationships, foreign_key: "course_id", class_name: "Relationship", dependent: :destroy
  has_many :programs, through: :reverse_relationships, source: :program

  validates :user_id, presence: true
  validates :description, presence: true
  validates :title, presence: true
end
