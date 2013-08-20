class AddFileTitleToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :file_title, :string

    notes = Note.find(:all)

    notes.each do |u|
       u.file_title = u.filename
       u.save
    end
  end
end
