class AddGradeToExams < ActiveRecord::Migration
  def change
    add_column :exams, :grade, :integer
  end
end
