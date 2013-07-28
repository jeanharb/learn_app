class Course < ActiveRecord::Base
  attr_accessible :description, :title
  belongs_to :user
  has_many :notes, dependent: :destroy

  validates :user_id, presence: true
  validates :description, presence: true
  validates :title, presence: true
end
