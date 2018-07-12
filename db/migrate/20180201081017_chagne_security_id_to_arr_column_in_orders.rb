class ChagneSecurityIdToArrColumnInOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :security_id
    add_column :orders, :security_ids, :integer, array: true
  end
end
