class CreateProgramratings < ActiveRecord::Migration
  def change
    create_table :programratings do |t|
      t.integer :rating
      t.integer :user_id
      t.integer :program_id
      t.text :review_content
      t.string :review_title

      t.timestamps
    end
    add_index :programratings, [:user_id, :program_id], unique: true
  end
end
