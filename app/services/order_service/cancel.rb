# frozen_string_literal: true

module OrderService
  class Cancel
    def initialize(attributes = {})
      @order_id = attributes.fetch(:order_id, nil)
    end

    def call
      order = ::Order.find_by_id(@order_id)
      raise "Order id not found" if order.nil?

      order.canceled!
    end
  end
end
