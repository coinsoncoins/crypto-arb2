
require './app/currency_converter'

class OrderBookEntry
  attr_accessor :quantity, :price, :price_usd, :order_book
  def initialize(quantity:, price:, side:, order_book:)
    @quantity = quantity.to_f.abs
    @price = price.to_f
    @side = side
    @order_book = order_book
    @price_usd = CurrencyConverter.to_usd(@price, @order_book.market.base)
    if !@price_usd
      raise StandardError.new("cannot convert order_book price")
    end
  end
end