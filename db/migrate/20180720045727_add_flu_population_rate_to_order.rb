class AddFluPopulationRateToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :flu_population_rate, :decimal, precision: 5, scale: 4
  end
end
