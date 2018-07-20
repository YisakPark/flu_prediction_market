class AddAvailableToLineShares < ActiveRecord::Migration[5.2]
  def change
    add_column :line_shares, :available, :boolean, default: true
  end
end
