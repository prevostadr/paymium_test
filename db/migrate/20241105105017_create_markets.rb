class CreateMarkets < ActiveRecord::Migration[7.2]
  def change
    create_table :markets do |t|
      t.integer :base
      t.integer :quote

      t.timestamps
    end
  end
end
