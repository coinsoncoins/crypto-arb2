class OrderBookEntry
  attr_accessor :quantity, :price
  def initialize(quantity:, price:, side:)
    @quantity = quantity.to_f
    @price = price.to_f
  end
end