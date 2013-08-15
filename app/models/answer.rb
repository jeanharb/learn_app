class Answer < ActiveRecord::Base
  attr_accessible :goodanswer, :name, :question_id
  belongs_to :question

  validates :question_id, presence: true
  validates :name, presence: true
end
