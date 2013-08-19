class AddRatingAlgoToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :rating_algo, :integer, default: 0
    add_index :courses, [:rating_algo, :created_at]
  end
end
