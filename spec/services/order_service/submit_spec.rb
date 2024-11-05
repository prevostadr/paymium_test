# frozen_string_literal: true
require 'rails_helper'

describe OrderService::Submit, type: :service do
  let(:order_info) { { "btc_amount": 1.1, "price": 2.125555555, "side": 'buy' } }
  let(:service) { OrderService::Submit.new(order: order_info) }

  describe '#call' do
    it 'order submit' do
      count_order_submitted = Order.submitted.count
      service.call
      expect(count_order_submitted).to be < Order.submitted.count
    end
  end
end
