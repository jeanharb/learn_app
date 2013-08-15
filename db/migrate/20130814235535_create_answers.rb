class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.text :name
      t.boolean :goodanswer, default: false

      t.timestamps
    end
  end
end
