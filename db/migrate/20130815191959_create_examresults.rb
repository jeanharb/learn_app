class CreateExamresults < ActiveRecord::Migration
  def change
    create_table :examresults do |t|
      t.integer :user_id
      t.integer :exam_id
      t.integer :finalgrade

      t.timestamps
    end
  end
end
