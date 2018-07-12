class ChangePrecisionOfCost < ActiveRecord::Migration[5.1]
  def change
    change_column :orders, :cost, :decimal, precision: 10, scale: 3
  end
end
