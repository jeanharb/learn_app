class Question < ActiveRecord::Base
  attr_accessible :exam_id, :name
  has_many :answers, dependent: :destroy
  belongs_to :exam

  accepts_nested_attributes_for :answers

  validates :exam_id, presence: true
  validates :name, presence: true
end
