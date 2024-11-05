class RenameColumnBtcAmount < ActiveRecord::Migration[7.2]
  def change
    rename_column :orders, :btc_amount, :amount
  end
end
