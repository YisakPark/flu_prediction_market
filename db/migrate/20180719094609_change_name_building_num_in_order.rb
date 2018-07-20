class ChangeNameBuildingNumInOrder < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :buildling_nums
    add_column :orders, :building_nums, :integer, array: true
  end
end
