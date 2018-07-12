class AddIndexToSecurities < ActiveRecord::Migration[5.1]
  def change
    add_index :securities, :event, unique: true
  end
end
