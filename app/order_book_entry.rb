
require './app/currency_converter'

class OrderBookEntry
  attr_accessor :quantity, :price, :price_usd
  def initialize(quantity:, price:, side:)
    @quantity = quantity.to_f.abs
    @price = price.to_f
    @side = side
    @price_usd = CurrencyConverter.btc_to_usd(@price)
  end
end