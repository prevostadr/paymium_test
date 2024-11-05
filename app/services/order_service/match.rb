# frozen_string_literal: true
require_relative '../user_service/transaction'

module OrderService
  class Match
    def initialize(attributes = {}); end

    def call
      nb_match = 0
      buyers.each do |buyer|

        seller_match = sellers.find_by(price: buyer['price'])
        next unless seller_match

        UserService::Transaction.new(buyer, seller_match).call
        nb_match += 1
        change_state_order(buyer, seller_match)
      end

      nb_match
    end

    def change_state_order(buyer, seller)
      buyer.finished!
      seller.finished!
    end

    def buyers
      Order.submitted.buy
    end

    def sellers
      Order.submitted.sell
    end
  end
end