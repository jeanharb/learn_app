class AddNumRatingToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :num_rating, :integer, default: 0
  end
end
