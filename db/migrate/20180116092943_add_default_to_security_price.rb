class AddDefaultToSecurityPrice < ActiveRecord::Migration[5.1]
  def change
    change_column :securities, :price, :decimal, precision: 5, scale: 3, default: 0
  end
end
