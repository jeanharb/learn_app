class AddNumcourToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :numcour, :integer, default: 0
  end
end
