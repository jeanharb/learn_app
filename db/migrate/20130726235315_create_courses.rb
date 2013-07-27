class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.integer :user_id
      t.text :description

      t.timestamps
    end
    add_index :courses, [:user_id, :created_at]
  end
end
