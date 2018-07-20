class RemoveSecurityGroupId < ActiveRecord::Migration[5.2]
  def change
    remove_column :market_status, :security_group_id
  end
end
