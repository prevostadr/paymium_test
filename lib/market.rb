class Market
  # def get_data
  #   JSON.parse(File.open('data.json').read)
  # end

  # Usage
  # require_relative 'main'
  # market = Market.new()
  # order_a = {"btc_amount": 1.1, "price": 2.125555555, "side": 'buy' }
  # market.submit(order_a)
  def submit(order)
    # filename = 'data.json'
    #
    # array = get_data
    # id = array["orders"].count
    # hash = {"id": array["orders"].count, "btc_amount": order[:btc_amount], "price": order[:price], "side": order[:side], "state": "submitted" }
    #
    # array["orders"] << hash
    #
    # File.open(filename, 'w') do |f|
    #   f.write(JSON.pretty_generate(array))
    # end
    #
    # id

    order = ::Order.create!(btc_amount: order[:btc_amount], price: order[:price], side: order[:side])
    order.id if order.submitted!
  end

  def market_price
    # data = get_data
    # orders = data['orders']
    #
    # buyers = orders.select { |order| order['side'] == 'buy' && order['state'] == "submitted" }
    # buyers_price = buyers.map{ _1["price"]}
    # buyers_price.sum(0.0) / buyers_price.size


    orders_submitted = ::Order.submitted
    buyers_price = orders_submitted.buy.map{ _1["price"]}
    average_price_buyers = buyers_price.sum(0.0) / buyers_price.size

    sellers_price = orders_submitted.sell.map{ _1["price"]}
    average_price_sellers = sellers_price.sum(0.0) / sellers_price.size

    (average_price_buyers + average_price_sellers) / 2
  end

  def market_depth
    orders_submitted = ::Order.submitted
    json = { "base"=>"BTC",
             "quote"=>"EUR"}

    json['bids'] = orders_submitted.buy.map { [_1.price, _1.btc_amount] }
    json['asks'] = orders_submitted.sell.map { [_1.price, _1.btc_amount] }
    json

    # data = get_data
    # orders = data['orders']
    #
    # buyers = orders.select { |order| order['side'] == 'buy' && order['state'] == "submitted" }
    # sellers = orders.select { |order| order['side'] == 'sell' && order['state'] == "submitted" }
    #
    #
    # json = { "base"=>"BTC",
    #          "quote"=>"EUR"}
    #
    # json['bids'] = buyers.map { [_1["price"], _1["btc_amount"]] }
    # json['asks'] = sellers.map { [_1["price"], _1["btc_amount"]] }
    # json
  end

  def cancel_order(id)
    order = Order.find_by_id(id)
    raise "Order id not found" if order.nil?

    order.canceled!
    # filename = 'data.json'
    #
    # array = JSON.parse(File.open('data.json').read)
    # array["orders"].find { _1['id'] == id }["state"] = "cancelled"
    #
    # File.open(filename, 'w') do |f|
    #   f.write(JSON.pretty_generate(array))
    # end
    #
    # id
  end
end