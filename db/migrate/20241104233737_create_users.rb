class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.decimal :btc_balance
      t.decimal :eur_balance

      t.timestamps
    end
  end
end
