class AddNumRatingToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :num_rating, :integer, default: 0
  end
end
