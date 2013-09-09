class CreateCompleteprograms < ActiveRecord::Migration
  def change
    create_table :completeprograms do |t|
      t.integer :user_id
      t.integer :program_id
      t.integer :progress

      t.timestamps
    end
  end
end
