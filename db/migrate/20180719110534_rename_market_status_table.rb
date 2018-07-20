class RenameMarketStatusTable < ActiveRecord::Migration[5.2]
  def change
    rename_table :market_status, :security_groups
  end
end
