class DropSecuritiesTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :securities, force: :cascade
  end
end
