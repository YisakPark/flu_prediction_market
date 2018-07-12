class ChangeAllScaleOfDecimal < ActiveRecord::Migration[5.1]
  def change
    change_column :line_securities, :quantity, :decimal, precision: 10, scale: 4
    change_column :orders, :quantity, :decimal, precision: 10, scale: 4
    change_column :orders, :cost, :decimal, precision: 10, scale: 4
    change_column :securities, :price, :decimal, precision: 5, scale: 4
    change_column :securities, :quantity, :decimal, precision: 10, scale: 4
    change_column :securities, :past_price, :decimal, precision: 5, scale: 4
    change_column :users, :money, :decimal, precision: 10, scale: 4
  end
end
