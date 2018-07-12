class AddCostToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :cost, :decimal, precision: 5, scale: 3
  end
end
