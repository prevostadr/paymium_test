class Order < ActiveRecord::Base
  enum :side, [:buy, :sell], validate: true
  enum :state, [:pending, :submitted, :canceled, :finished], default: :pending
end
