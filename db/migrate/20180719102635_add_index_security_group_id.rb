class AddIndexSecurityGroupId < ActiveRecord::Migration[5.2]
  def change 
    add_index :market_status, :security_group_id, unique: true
  end
end
