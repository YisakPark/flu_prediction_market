class AddTimestampToSeveralTables < ActiveRecord::Migration[5.2]
  def change
    add_column :past_prices, :created_at, :datetime, null: false
    add_column :past_prices, :updated_at, :datetime, null: false

    add_column :security_groups, :created_at, :datetime, null: false
    add_column :security_groups, :updated_at, :datetime, null: false
  end
end
