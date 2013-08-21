class AddPositionToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :position, :integer
    @programs = Program.find(:all)
    @programs.each do |program|
      index = 0
      program.relationships.each do |course|
        course.position = index
        course.save
        index += 1
      end
    end
  end
end
