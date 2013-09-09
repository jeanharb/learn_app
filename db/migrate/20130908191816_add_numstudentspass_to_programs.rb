class AddNumstudentspassToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :numstudentspass, :integer, default: 0
  end
end
