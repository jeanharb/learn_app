class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :course_id
      t.integer :program_id

      t.timestamps
    end

    add_index :relationships, :course_id
    add_index :relationships, :program_id
    add_index :relationships, [:program_id, :course_id], unique: true
  end
end
