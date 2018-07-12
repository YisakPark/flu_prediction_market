class AddQuantityToSecurities < ActiveRecord::Migration[5.1]
  def change
    add_column :securities, :quantity, :decimal, default: 0
  end
end
