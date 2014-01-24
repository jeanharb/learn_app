class AddPrereqposToRelationships < ActiveRecord::Migration
  def change
  	add_column :relationships, :prereqpos, :integer, default: 0
  end
end
