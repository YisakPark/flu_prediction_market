class AddSharesGroupIdMarketStatusTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :market_status, :flu_population_rate
    add_column :market_status, :security_group_id, :integer
    add_column :market_status, :shares, :integer
  end
end
