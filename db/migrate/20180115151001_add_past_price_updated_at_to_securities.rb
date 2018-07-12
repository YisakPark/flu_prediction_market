class AddPastPriceUpdatedAtToSecurities < ActiveRecord::Migration[5.1]
  def change
    add_column :securities, :past_price_updated_at, :datetime, default: Time.current, null: false
  end
end
