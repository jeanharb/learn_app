class Answer < ActiveRecord::Base
  attr_accessible :goodanswer, :name
  belongs_to :question

  validates :question_id, presence: true
  validates :name, presence: true, :length => { :minimum => 1 }
end
