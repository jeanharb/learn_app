class CreateCourseratings < ActiveRecord::Migration
  def change
    create_table :courseratings do |t|
      t.integer :rating
      t.integer :user_id
      t.integer :course_id
      t.text :review_content
      t.string :review_title

      t.timestamps
    end
    add_index :courseratings, [:user_id, :course_id], unique: true
  end
end
