class AddPastPriceToPastPrice < ActiveRecord::Migration[5.2]
  def change
    add_column :past_prices, :past_price, :decimal, precision: 5, scale: 4
  end
end
