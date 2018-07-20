class BuildingNumInteger < ActiveRecord::Migration[5.2]
  def change
    remove_column :buildings, :number
    add_column :buildings, :building_num, :integer
    remove_column :line_shares, :building
    add_column :line_shares, :building_num, :integer
    remove_column :market_status, :building
    add_column :market_status, :building_num, :integer
    remove_column :orders, :building
    add_column :orders, :building_num, :integer
    remove_column :past_prices, :building
    add_column :past_prices, :building_num, :integer

  end
end
