class AddContenttypeToNotes < ActiveRecord::Migration
  def change
  	add_column :notes, :contenttype, :string
  end
end
