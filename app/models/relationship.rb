class Relationship < ActiveRecord::Base
  attr_accessible :program_id, :course_id
  belongs_to :course, class_name: "Course"
  belongs_to :program, class_name: "Program"
  acts_as_list scope: :program

  before_destroy :destroy_all_prerequisites

  validates :program_id, presence: true
  validates :course_id, presence: true

  private

  	def destroy_all_prerequisites
  		@prerequisites_want = Prerequisite.where("want_id = ?", course_id).where("wantpro_id = ?", program_id)
  		@prerequisites_req = Prerequisite.where("required_id = ?", course_id).where("wantpro_id = ?", program_id)
  		@prerequisites_req.each do |prereq|
  			prereq.destroy
  		end
  		@prerequisites_want.each do |prereq|
  			prereq.destroy
  		end
  	end
end
