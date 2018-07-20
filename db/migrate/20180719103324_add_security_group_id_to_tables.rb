class AddSecurityGroupIdToTables < ActiveRecord::Migration[5.2]
  def change
    remove_column :buildings, :shares
    
    add_column :line_shares, :date_market, :string
    add_column :line_shares, :security_group_id, :integer

    add_column :orders, :security_group_id, :integer

    add_column :past_prices, :security_group_id, :integer

    add_column :market_status, :isClosed?, :boolean, default: false
  end
end
