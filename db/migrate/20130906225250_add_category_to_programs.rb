class AddCategoryToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :category, :integer, default: 0
  end
end
