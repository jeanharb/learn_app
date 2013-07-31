class Cart < ActiveRecord::Base
  attr_accessible :coursefollow_id, :follower_id
  belongs_to :coursefollow, class_name: "Course"
  belongs_to :follower, class_name: "User"

  validates :coursefollow_id, presence: true
  validates :follower_id, presence: true
end