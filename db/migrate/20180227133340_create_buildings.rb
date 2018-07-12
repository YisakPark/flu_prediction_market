class CreateBuildings < ActiveRecord::Migration[5.1]
  def change
    create_table :buildings do |t|
      t.string :building
      t.integer :floors

      t.timestamps
    end
  end
end
