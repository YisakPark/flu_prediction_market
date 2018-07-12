class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :securities, :events, :event  
  end
end
