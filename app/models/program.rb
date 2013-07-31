class Program < ActiveRecord::Base
  attr_accessible :description, :title
  belongs_to :user
  has_many :relationships, foreign_key: "program_id", dependent: :destroy
  has_many :courses, through: :relationships, source: :course

  validates :user_id, presence: true
  validates :description, presence: true
  validates :title, presence: true

  def cours
  	Course.where("programs = ?", id)
  end

  def takingclass?(course)
    relationships.find_by(course_id: course.id)
  end

  def takeclass!(course)
    relationships.create!(course_id: course.id)
  end

  def removeclass!(course)
    relationships.find_by(followed_id: course.id).destroy!
  end
end
