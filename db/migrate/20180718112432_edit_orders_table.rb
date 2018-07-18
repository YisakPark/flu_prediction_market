class EditOrdersTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :security_ids
    add_column :orders, :date_market, :string
    add_column :orders, :building, :string
  end
end
