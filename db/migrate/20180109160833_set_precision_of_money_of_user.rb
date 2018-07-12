class SetPrecisionOfMoneyOfUser < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :money, :decimal, precision: 10, scale: 3
  end
end
