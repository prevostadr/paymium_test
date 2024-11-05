# frozen_string_literal: true

nb_orders = 50

nb_orders.times do
  order_info = {amount: 1.0, price: rand(1.0..5.00), fee: 0.125, market_id: Market.pluck(:id).sample }
  order_info[:side] = 'buy'
  order_info[:user_id] = User.first.id
  order_a = Order.create!(order_info)

  order_info[:side] = 'sell'
  order_info[:user_id] = User.last.id
  order_b = Order.create!(order_info)
  next unless [true, false].sample

  order_a.submitted!
  order_b.submitted!
end