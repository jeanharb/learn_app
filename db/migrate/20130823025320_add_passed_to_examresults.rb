class AddPassedToExamresults < ActiveRecord::Migration
  def change
    add_column :examresults, :passed, :string, default: "false"
  end
end
