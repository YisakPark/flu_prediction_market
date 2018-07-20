class MakeBuildingNumInOrdersArray < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :building_num
    add_column :orders, :buildling_nums, :integer, array: true
  end
end
