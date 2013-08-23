class Prerequisite < ActiveRecord::Base
  attr_accessible :want_id, :required_id
  belongs_to :required, class_name: "Course"
  belongs_to :want, class_name: "Course"
  belongs_to :wantpro, class_name: "Program"

  before_save :class_in_program

  validates :wantpro_id, presence: true
  validates :want_id, presence: true
  validates :required_id, presence: true

  private
  	def verify_no_circular_requirements
  		return true
  	end

    def class_in_program
      @program = Program.find(wantpro_id)
      @course_want = Course.find(want_id)
      @course_req = Course.find(required_id)
      if @program.takingclass?(@course_want) and @program.takingclass?(@course_req)
        return true
      else
        return false
      end
    end
end