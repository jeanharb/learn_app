class AddNumprogToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :numprog, :integer, default: 0
  end
end
