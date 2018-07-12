class CreateShares < ActiveRecord::Migration[5.1]
  def change
    create_table :shares do |t|
      t.decimal :sell_price
      t.decimal :buy_price
      t.integer :quantity

      t.timestamps
    end
  end
end
