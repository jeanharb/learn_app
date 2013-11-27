class CreateNumberUsers < ActiveRecord::Migration
  def change
    create_table :number_users do |t|
      t.string :date
      t.integer :num_users

      t.timestamps
    end
  end
end
