class CreateExams < ActiveRecord::Migration
  def change
    create_table :exams do |t|
      t.integer :course_id
      t.text :name

      t.timestamps
    end
  end
end
