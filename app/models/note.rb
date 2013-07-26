class Note < ActiveRecord::Base
  attr_accessible :content, :filename
  belongs_to :user

  validates :content, presence: true
  validates :user_id, presence: true
  validates :filename, presence: true

  default_scope order: 'notes.created_at DESC'

  def filename1
  	@filename1
  end

  def content1
  	@content1
  end
end
