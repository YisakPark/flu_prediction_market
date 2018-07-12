class ChangeColumnGroupInSecurities < ActiveRecord::Migration[5.1]
  def change
    rename_column :securities, :group, :building_number
  end
end
