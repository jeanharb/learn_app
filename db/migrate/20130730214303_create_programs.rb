class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.string :title
      t.integer :user_id
      t.text :description

      t.timestamps
    end
    add_index :programs, [:user_id, :created_at]
  end
end
