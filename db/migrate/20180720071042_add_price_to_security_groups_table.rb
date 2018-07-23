class AddPriceToSecurityGroupsTable < ActiveRecord::Migration[5.2]
  def change
    add_column :security_groups, :price, :decimal, precision: 5, scale: 4
  end
end
