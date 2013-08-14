class Prerequisite < ActiveRecord::Base
  attr_accessible :want_id, :required_id
  belongs_to :required, class_name: "Course"
  belongs_to :want, class_name: "Course"
  belongs_to :wantpro, class_name: "Program"

  validates :wantpro_id, presence: true
  validates :want_id, presence: true
  validates :required_id, presence: true

  private
  	def verify_no_circular_requirements
  		return true
  	end
end