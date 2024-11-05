# frozen_string_literal: true
require 'rails_helper'

describe UserService::Transaction, type: :service do
  let(:fee) {0.125}
  let(:eur_balance) {BigDecimal(10000)}
  let(:buyer) { User.create!(btc_balance: 0, eur_balance: eur_balance) }
  let(:seller) { User.create!(btc_balance: 2.0, eur_balance: eur_balance) }
  let(:order_info_buyer) { { "btc_amount": 1.0, "price": 2.0, "side": 'buy', user_id: buyer.id } }
  let(:order_info_seller) { { "btc_amount": 1.0, "price": 2.0, "side": 'sell', user_id: seller.id } }
  let(:order_buyer) { Order.find_by_id(OrderService::Submit.new(order: order_info_buyer).call) }
  let(:order_seller) { Order.find_by_id(OrderService::Submit.new(order: order_info_seller).call) }

  let(:service) { UserService::Transaction.new(order_buyer, order_seller) }

  describe '#call' do
    it 'Change user info without fee' do
      expect { service.call }.to change { buyer.reload.btc_balance }.by(order_buyer.btc_amount)
                                                                    .and change { seller.reload.btc_balance }.by(- order_seller.btc_amount)
                                                                    .and change { buyer.eur_balance}.by(- order_buyer.price)
                                                                    .and change { seller.eur_balance}.by(order_seller.price)
    end

    it 'Change user info with fee' do
      order_info_buyer["fee"] = fee
      order_info_seller["fee"] = fee
      order_buyer_with_fee = Order.find_by_id(OrderService::Submit.new(order: order_info_buyer).call)
      order_seller_with_fee = Order.find_by_id(OrderService::Submit.new(order: order_info_seller).call)
      service = UserService::Transaction.new(order_buyer_with_fee, order_seller_with_fee)

      expect { service.call }.to change { buyer.reload.btc_balance }.by(order_buyer.btc_amount)
                                                                    .and change { seller.reload.btc_balance }.by(- order_seller.btc_amount)
                                                                    .and change { buyer.eur_balance}.by(-(order_buyer.price + ((order_buyer_with_fee.btc_amount * order_buyer_with_fee.price) * fee / 100)))
                                                                    .and change { seller.eur_balance}.by(order_seller.price - ((order_seller_with_fee.btc_amount * order_seller_with_fee.price) * fee / 100))
    end
  end
end
