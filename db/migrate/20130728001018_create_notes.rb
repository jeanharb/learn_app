class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :content
      t.integer :course_id

      t.timestamps
    end
    add_index :notes, [:course_id, :created_at]
  end
end
