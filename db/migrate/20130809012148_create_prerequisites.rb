class CreatePrerequisites < ActiveRecord::Migration
  def change
    create_table :prerequisites do |t|
      t.integer :wantpro_id
      t.integer :want_id
      t.integer :required_id

      t.timestamps
    end
    add_index :prerequisites, :want_id
    add_index :prerequisites, :wantpro_id
    add_index :prerequisites, :required_id
    add_index :prerequisites, [:want_id, :wantpro_id, :required_id], unique: true
  end
end
