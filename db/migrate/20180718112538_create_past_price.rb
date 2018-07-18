class CreatePastPrice < ActiveRecord::Migration[5.2]
  def change
    create_table :past_prices do |t|
      t.string :building
      t.string :date_market
    end
  end
end
