class AddPositionToExams < ActiveRecord::Migration
  def change
    add_column :exams, :position, :integer
    @courses = Course.find(:all)
    @courses.each do |course|
      index = 0
      course.exams.each do |exam|
        exam.position = index
        exam.save
        index += 1
      end
    end
  end
end
