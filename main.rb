require 'json'
require_relative 'config/application.rb'
require_relative 'app/models/order'
require_relative 'app/models/user'
require_relative 'app/models/market'

require_relative 'app/services/market_service_object'

def market
  MarketServiceObject.new
end