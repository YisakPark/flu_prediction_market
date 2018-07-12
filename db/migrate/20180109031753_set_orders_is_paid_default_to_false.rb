class SetOrdersIsPaidDefaultToFalse < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders, :isPaid, :isDone
  end
end
