class CreateSecurities < ActiveRecord::Migration[5.1]
  def change
    create_table :securities do |t|
      t.string :group
      t.string :events
      t.decimal :price

      t.timestamps
    end
  end
end
