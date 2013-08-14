class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :student_id
      t.integer :takenprog_id

      t.timestamps
    end
    add_index :registrations, :takenprog_id
    add_index :registrations, :student_id
    add_index :registrations, [:takenprog_id, :student_id], unique: true

    drop_table :registerations
  end
end