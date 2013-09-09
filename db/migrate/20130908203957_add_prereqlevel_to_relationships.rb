class AddPrereqlevelToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :prereqlevel, :integer, default: 40
  end
end
