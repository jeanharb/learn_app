class AddNumstudentspassToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :numstudentspass, :integer, default: 0
  end
end
