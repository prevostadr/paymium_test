class Order < ActiveRecord::Base
  belongs_to :user, optional: true

  enum :side, [:buy, :sell], validate: true
  enum :state, [:pending, :submitted, :canceled, :finished], default: :pending
end
