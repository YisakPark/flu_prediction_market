class AddPrecisionAndScale < ActiveRecord::Migration[5.1]
  def change
    change_column :securities, :price, :decimal, precision: 5, scale: 3
    change_column :securities, :quantity, :decimal, precision: 10, scale: 3
    change_column :line_securities, :quantity, :decimal, precision: 10, scale: 3
  end
end
