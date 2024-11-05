class AddMarketToOrder < ActiveRecord::Migration[7.2]
  def change
    add_reference :orders, :market, foreign_key: true
  end
end
