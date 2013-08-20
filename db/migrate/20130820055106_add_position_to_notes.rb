class AddPositionToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :position, :integer

    @courses = Course.find(:all)
    @courses.each do |course|
    	index = 0
    	course.notes.each do |note|
    		note.position = index
    		note.save
    		index += 1
    	end
    end
  end
end
