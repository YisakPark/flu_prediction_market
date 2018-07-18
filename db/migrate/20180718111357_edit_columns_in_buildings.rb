class EditColumnsInBuildings < ActiveRecord::Migration[5.2]
  def change
    remove_column :buildings, :floors
    add_column :buildings, :shares, :integer
  end
end
