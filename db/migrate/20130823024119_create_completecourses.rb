class CreateCompletecourses < ActiveRecord::Migration
  def change
    create_table :completecourses do |t|
      t.integer :course_id
      t.integer :user_id
      t.string 	:passed

      t.timestamps
    end
    add_index :completecourses, [:user_id, :course_id], unique: true
  end
end
