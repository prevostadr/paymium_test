class Order < ActiveRecord::Base
  belongs_to :user, optional: true
  belongs_to :market

  enum :side, [:buy, :sell], validate: true
  enum :state, [:pending, :submitted, :canceled, :finished], default: :pending

  before_validation :set_default_market

  private

  def set_default_market
    return unless self.market.nil?

    self.market = Market.find_or_create_by(base: 'btc')
  end
end
