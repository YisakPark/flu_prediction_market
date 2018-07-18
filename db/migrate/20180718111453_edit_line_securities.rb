class EditLineSecurities < ActiveRecord::Migration[5.2]
  def change
    rename_table :line_securities, :line_shares
    add_column :line_shares, :building, :string
    add_column :line_shares, :flu_population_rate, :decimal, precision: 5, scale: 4
    remove_column :line_shares, :security_id
  end
end
