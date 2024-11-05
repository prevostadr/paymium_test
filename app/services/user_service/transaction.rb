# frozen_string_literal: true

module UserService
  class Transaction
    def initialize(order_buyer, order_seller)
      @order_buyer = order_buyer
      @order_seller = order_seller
      @market_base = order_buyer.market.base
    end

    def call
      seller = @order_seller.user
      buyer = @order_buyer.user
      users_not_found(buyer, seller)
      enough_eur(buyer, @order_buyer.price)
      send("enough_#{@market_base}", seller, @order_seller.amount)

      buyer_change(buyer)
      seller_change(seller)
    end

    def buyer_change(buyer)
      buyer.eur_balance -= BigDecimal(@order_buyer.price + fee_in_euro(@order_seller))
      base_balance = buyer.send("#{@market_base}_balance") + BigDecimal(@order_buyer.amount)

      buyer.send("#{@market_base}_balance" + '=', base_balance)
      buyer.save!
    end

    def seller_change(seller)
      seller.eur_balance += BigDecimal(@order_seller.price - fee_in_euro(@order_seller))
      base_balance = seller.send("#{@market_base}_balance") - BigDecimal(@order_seller.amount)

      seller.send("#{@market_base}_balance" + '=', base_balance)
      seller.save!
    end

    def fee_in_euro(order)
      fee = order.fee.to_f
      (order.amount * order.price) * fee / 100
    end

    private
    def enough_eth(user, eth_amount)
      raise 'Not enough eth' if (user.eth_balance - eth_amount).negative?
    end

    def enough_btc(user, amount)
      raise 'Not enough btc' if (user.btc_balance - amount).negative?
    end

    def enough_eur(user, price)
      raise 'Not enough euro' if (user.eur_balance - price).negative?
    end

    def users_not_found(buyer, seller)
      raise 'Buyer not found' if buyer.nil?
      raise 'Seller not found' if  seller.nil?
    end
  end
end