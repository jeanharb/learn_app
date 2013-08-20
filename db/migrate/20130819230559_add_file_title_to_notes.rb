class AddFileTitleToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :file_title, :string
    end
  end
end
