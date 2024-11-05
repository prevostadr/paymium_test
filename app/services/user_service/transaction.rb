# frozen_string_literal: true

module UserService
  class Transaction
    def initialize(order_buyer, order_seller)
      @order_buyer = order_buyer
      @order_seller = order_seller
    end

    def call
      seller = @order_seller.user
      buyer = @order_buyer.user
      users_not_found(buyer, seller)
      enough_btc(seller, @order_seller.btc_amount)
      enough_eur(buyer, @order_buyer.price)
      buyer_change(buyer)
      seller_change(seller)
    end

    def buyer_change(buyer)
      buyer.eur_balance -= BigDecimal(@order_buyer.price)
      buyer.btc_balance += BigDecimal(@order_buyer.btc_amount)

      buyer.save!
    end

    def seller_change(seller)
      seller.eur_balance += BigDecimal(@order_seller.price)
      seller.btc_balance -= BigDecimal(@order_seller.btc_amount)

      seller.save!
    end

    def enough_btc(user, btc_amount)
      raise 'Not enough btc' if (user.btc_balance - btc_amount).negative?
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