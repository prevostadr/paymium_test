class AddEthBalanceToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :eth_balance, :decimal
  end
end
