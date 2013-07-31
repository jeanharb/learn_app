class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :coursefollow_id
      t.integer :follower_id

      t.timestamps
    end

    add_index :carts, :coursefollow_id
    add_index :carts, :follower_id
    add_index :carts, [:follower_id, :coursefollow_id], unique: true
  end
end
