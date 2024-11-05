class Market < ActiveRecord::Base
  has_many :orders, dependent: :destroy

  enum :base, [:btc, :eth], validate: true
  enum :quote, [:euro], validate: true, default: :euro
end
