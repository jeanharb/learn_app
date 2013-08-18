class AddAverageRatingToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :average_rating, :decimal, precision: 2, scale: 1, default: 0
  end
end
