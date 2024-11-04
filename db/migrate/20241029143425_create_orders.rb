class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.decimal :btc_amount
      t.decimal :price
      t.integer :side
      t.integer :state

      t.timestamps
    end
  end
end
