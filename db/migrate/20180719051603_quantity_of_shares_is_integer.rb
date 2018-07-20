class QuantityOfSharesIsInteger < ActiveRecord::Migration[5.2]
  def change
    remove_column :line_shares, :quantity
    add_column :line_shares, :quantity, :integer
    remove_column :orders, :quantity
    add_column :orders, :quantity, :integer
  end
end
