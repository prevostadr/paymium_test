# frozen_string_literal: true
require 'rails_helper'

describe OrderService::Cancel, type: :service do
  let(:order_info) { { "btc_amount": 1.1, "price": 2.125555555, "side": 'buy' } }
  let(:order_a) { Order.create!(order_info) }
  let(:service) { OrderService::Cancel.new(order_id: order_a.id) }

  describe '#call' do
    it 'order cancel' do
      expect(order_a.state).not_to eq 'canceled'
      service.call
      expect(order_a.reload.state).to eq 'canceled'
    end
  end
end
