class AddPositionToRelationships < ActiveRecord::Migration
  def change
    add_column :relationships, :position, :integer
  end
end
