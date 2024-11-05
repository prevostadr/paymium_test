# frozen_string_literal: true

number_users = 2
number_users.times do
  User.create!(
    btc_balance: 1000000,
    eth_balance: 10,
    eur_balance: 1000
  )
end
