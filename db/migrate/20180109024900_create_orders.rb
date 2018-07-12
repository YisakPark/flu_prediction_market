class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :user
      t.references :security
      t.boolean :isPaid
      t.decimal :quantity, precision: 10, scale: 3

      t.timestamps
    end
  end
end
