class CreateLineSecurities < ActiveRecord::Migration[5.1]
  def change
    create_table :line_securities do |t|
      t.decimal :quantity
      t.decimal :price
      t.references :user, foreign_key:
      t.timestamps
    end
  end
end
