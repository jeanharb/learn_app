class Note < ActiveRecord::Base
  attr_accessible :content, :filename, :contenttype
  belongs_to :course

  validates :course_id, presence: true
  validates :content, presence: true
  validates :filename, presence: true
  validates :contenttype, presence: true

  def as_file
  	output = Base64.decode64(self.content)
  end
end
