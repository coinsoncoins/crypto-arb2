require './app/order_book_entry'
require "active_support/hash_with_indifferent_access"

class OrderBook
  attr_reader :book

  def initialize()
    @book = ActiveSupport::HashWithIndifferentAccess.new({bid: [], ask: []})
    @has_been_ordered = false
  end

  def bids
    @book["bid"]
  end

  def asks
    @book["ask"]
  end

  def add_entry(quantity:, price:, side:)
    side = side.to_s
    verify_side(side)
    @book[side].push(OrderBookEntry.new(quantity: quantity.to_f, price: price.to_f, side: side))
    @has_been_ordered = false
    self
  end

  def verify_side(side)
    if !%w[bid ask].include?(side)
      raise RuntimeError.new("OrderBook: unknown side #{side}")
    end
  end

  def verify_ordered()
    if !@has_been_ordered
      raise RuntimeError.new("OrderBook: has not been ordered")
    end
  end

  def finish_adding_entries()
    @book['bid'] = @book['bid'].sort_by { |bid| bid.price }.reverse
    @book['ask'] = @book['ask'].sort_by { |ask| ask.price }
    @has_been_ordered = true
    self
  end

  def get_cost_of_side(side, cutoff=nil)
    verify_ordered()
    side = side.to_s
    book_side = @book[side]
    cost = 0.0
    book_side.each do |entry|
      break if cutoff && 
        (side == "bid" && entry.price < cutoff || side == "ask" && entry.price > cutoff)
      cost += entry.price * entry.quantity
    end
    cost
  end

  def deep_clone()
    Marshal.load( Marshal.dump(self) )
  end

end