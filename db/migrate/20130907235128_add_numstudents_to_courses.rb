class AddNumstudentsToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :numstudents, :integer, default: 0
  end
end
