class AddFilenameToNotes < ActiveRecord::Migration
  def change
  	add_column :notes, :filename, :string
  end
end
