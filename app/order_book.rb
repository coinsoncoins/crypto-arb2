require './app/order_book_entry'

class OrderBook
  attr_reader :bids, :asks

  def initialize()
    @bids = []
    @asks = []
  end

  def add_entry(quantity:, price:, side:)
    if side == "bid"
      @bids.push(OrderBookEntry.new(quantity: quantity.to_f, price: price.to_f, side: side))
    elsif side == "ask"
      @asks.push(OrderBookEntry.new(quantity: quantity.to_f, price: price.to_f, side: side))
    else
      raise RuntimeError.new("unknown side #{side}")
    end
    self
  end

  def finish_adding_entries()
    @bids = @bids.sort_by { |bid| bid.price }.reverse
    @asks = @asks.sort_by { |ask| ask.price }
    self
  end

end