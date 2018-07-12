class AddShareQuantityAndMoneyToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :share_quantity, :integer, default: 0
    add_column :users, :money, :decimal, default: 100
  end
end
