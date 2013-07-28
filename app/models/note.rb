class Note < ActiveRecord::Base
  attr_accessible :content, :filename
  belongs_to :course

  validates :course_id, presence: true
  validates :content, presence: true
  validates :filename, presence: true
end
