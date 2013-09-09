class Completeprogram < ActiveRecord::Base
  attr_accessible :program_id, :progress
  belongs_to :user
  belongs_to :program

  validates :user_id, presence: true
  validates :program_id, presence: true
  validates :progress, presence: true
end
