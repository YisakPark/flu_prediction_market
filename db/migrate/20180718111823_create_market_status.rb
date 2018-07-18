class CreateMarketStatus < ActiveRecord::Migration[5.2]
  def change
    create_table :market_status do |t|
      t.string :date_market
      t.string :building
      t.decimal :flu_population_rate, precision: 5, scale: 4
    end
  end
end
