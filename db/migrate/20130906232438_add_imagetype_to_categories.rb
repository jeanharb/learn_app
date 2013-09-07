class AddImagetypeToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :imagetype, :string
  end
end
