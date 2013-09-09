class RemovePrereqlevelFromPrerequisites < ActiveRecord::Migration
  def up
  	remove_index :prerequisites, :column => [ :want_id, :wantpro_id, :required_id ]
  end
end
