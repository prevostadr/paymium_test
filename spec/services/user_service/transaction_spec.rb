# frozen_string_literal: true
require 'rails_helper'

describe UserService::Transaction, type: :service do
  let(:eur_balance) {BigDecimal(10000)}
  let(:buyer) { User.create!(btc_balance: 0, eur_balance: eur_balance) }
  let(:seller) { User.create!(btc_balance: 1.0, eur_balance: eur_balance) }
  let(:order_info_buyer) { { "btc_amount": 1.0, "price": 2.0, "side": 'buy', user_id: buyer.id } }
  let(:order_info_seller) { { "btc_amount": 1.0, "price": 2.0, "side": 'sell', user_id: seller.id } }
  let(:order_buyer) { Order.find_by_id(OrderService::Submit.new(order: order_info_buyer).call) }
  let(:order_seller) { Order.find_by_id(OrderService::Submit.new(order: order_info_seller).call) }

  let(:service) { UserService::Transaction.new(order_buyer, order_seller) }

  describe '#call' do
    it 'Change user info' do
      expect { service.call }.to change { buyer.reload.btc_balance }.by(order_buyer.btc_amount)
                                                                    .and change { seller.reload.btc_balance }.by(- order_seller.btc_amount)
                                                                    .and change { buyer.eur_balance}.by(- order_buyer.price)
                                                                    .and change { seller.eur_balance}.by(order_seller.price)
    end
  end
end
