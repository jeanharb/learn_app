class CreateCourseregistrations < ActiveRecord::Migration
  def change
    create_table :courseregistrations do |t|
      t.integer :courstudent_id
      t.integer :takencourse_id

      t.timestamps
    end
    add_index :courseregistrations, :takencourse_id
    add_index :courseregistrations, :courstudent_id
    add_index :courseregistrations, [:takencourse_id, :courstudent_id], unique: true
  end
end
