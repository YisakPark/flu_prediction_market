class AddPastPriceToSecurity < ActiveRecord::Migration[5.1]
  def change
    add_column :securities, :past_price, :decimal, precision: 5, scale: 3, default: 0
  end
end
