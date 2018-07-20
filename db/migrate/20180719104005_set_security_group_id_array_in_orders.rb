class SetSecurityGroupIdArrayInOrders < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :security_group_id
    add_column :orders, :security_group_ids, :integer, array: true
  end
end
