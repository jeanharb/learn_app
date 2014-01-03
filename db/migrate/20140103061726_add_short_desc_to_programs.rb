class AddShortDescToPrograms < ActiveRecord::Migration
  def change
    add_column :programs, :short_desc, :string
  end
end
