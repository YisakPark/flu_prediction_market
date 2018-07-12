class AddSecurityIdToLineSecurities < ActiveRecord::Migration[5.1]
  def change
    add_reference :line_securities, :security, foreign_key: true
  end
end
