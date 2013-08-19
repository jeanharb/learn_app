class AddRatingAlgoToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :rating_algo, :integer, default: 0
    add_index :programs, [:rating_algo, :created_at]
  end
end
