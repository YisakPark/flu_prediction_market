class AddAnotherIndexToSecurities < ActiveRecord::Migration[5.1]
  def change
    add_index :securities, :id, unique: true
  end
end
