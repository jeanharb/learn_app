class AddNumstudentsToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :numstudents, :integer, default: 0
  end
end
