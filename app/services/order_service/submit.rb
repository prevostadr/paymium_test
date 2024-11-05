# frozen_string_literal: true

module OrderService
  class Submit
    def initialize(attributes = {})
      order = attributes.fetch(:order, {})
      order.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def call
      order = Order.create!(btc_amount: @btc_amount, price: @price, side: @side, user_id: @user_id, fee: @fee)
      order.id if order.submitted!
    end
  end
end
