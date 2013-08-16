class Question < ActiveRecord::Base
  attr_accessible :name
  has_many :answers, dependent: :destroy
  belongs_to :exam

  accepts_nested_attributes_for :answers

  validates :exam_id, presence: true
  validates :name, presence: true, :length => { :minimum => 2 }
end
