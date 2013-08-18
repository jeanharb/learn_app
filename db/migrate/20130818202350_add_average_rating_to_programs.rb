class AddAverageRatingToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :average_rating, :decimal, precision: 2, scale: 1, default: 0
  end
end
