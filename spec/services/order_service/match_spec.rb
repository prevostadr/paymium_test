# frozen_string_literal: true
require 'rails_helper'

describe OrderService::Match, type: :service do
  before do
    eur_balance = BigDecimal(10000)
    buyer = User.create!(btc_balance: 0, eur_balance: eur_balance)
    seller = User.create!(btc_balance: 1.0, eur_balance: eur_balance)
    order_info_buyer = { "btc_amount": 1.0, "price": 2.0, "side": 'buy', user_id: buyer.id }
    order_info_seller = { "btc_amount": 1.0, "price": 2.0, "side": 'sell', user_id: seller.id }
    Order.find_by_id(OrderService::Submit.new(order: order_info_buyer).call)
    Order.find_by_id(OrderService::Submit.new(order: order_info_seller).call)
  end

  describe '#call' do
    it 'order match' do
      service = OrderService::Match.new
      response = service.call
      expect(response).to be(1)
    end
  end
end
