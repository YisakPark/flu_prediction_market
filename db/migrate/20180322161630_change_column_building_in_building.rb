class ChangeColumnBuildingInBuilding < ActiveRecord::Migration[5.1]
  def change
    rename_column :buildings, :building, :number
  end
end
