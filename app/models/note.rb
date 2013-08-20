class Note < ActiveRecord::Base
  attr_accessible :content, :filename, :contenttype, :file_title
  belongs_to :course
  acts_as_list scope: :course

  validates :course_id, presence: true
  validates :content, presence: true
  validates :filename, presence: true
  validates :contenttype, presence: true
  validates :file_title, presence: true

  def as_file
  	output = Base64.decode64(self.content)
  end
end
