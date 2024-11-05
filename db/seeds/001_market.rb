# frozen_string_literal: true

market = [{
            base: 'btc',
            quote: 'euro',
          },
          {
            base: 'eth',
            quote: 'euro',
          }]

market.each do
  Market.create!(
    base: _1[:base],
    quote: _1[:quote]
  )
end
