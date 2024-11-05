# frozen_string_literal: true
require_relative 'order_service/submit.rb'
require_relative 'order_service/cancel.rb'
require_relative 'order_service/match.rb'

class MarketServiceObject

  def submit(order)
    OrderService::Submit.new(order: order).call
  end

  def market_price
    orders_submitted = Order.submitted
    buyers_price = orders_submitted.buy.map{ _1["price"]}
    average_price_buyers = buyers_price.sum(0.0) / buyers_price.size

    sellers_price = orders_submitted.sell.map{ _1["price"]}
    average_price_sellers = sellers_price.sum(0.0) / sellers_price.size

    (average_price_buyers + average_price_sellers) / 2
  end

  def market_depth
    orders_submitted = Order.submitted
    json = { "base"=>"BTC",
             "quote"=>"EUR"}

    json['bids'] = orders_submitted.buy.map { [_1.price, _1.btc_amount] }
    json['asks'] = orders_submitted.sell.map { [_1.price, _1.btc_amount] }
    json
  end

  def cancel_order(order_id)
    OrderService::Cancel.new(order_id: order_id).call
  end

  def match
    OrderService::Match.new.call
  end
end
