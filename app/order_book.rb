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

  def arb_order_books(other_book)
    self.verify_ordered()
    other_book.verify_ordered()
    total_profit = 0.0
    book1, book2 = self.deep_clone, other_book.deep_clone
    while true
      lowest_ask = book1.asks.first
      highest_bid = book2.bids.first
      break if !lowest_ask or !highest_bid
      min_quantity = [lowest_ask.quantity, highest_bid.quantity].min
      # execute the sale
      lowest_ask.quantity -= min_quantity
      highest_bid.quantity -= min_quantity
      profit = min_quantity * (highest_bid.price - lowest_ask.price)
      break if profit <= 0
      book1.asks.shift if lowest_ask.quantity <= 0.0001
      book2.bids.shift if highest_bid.quantity <= 0.0001
      total_profit += profit
    end
    total_profit
  end

  def deep_clone()
    Marshal.load( Marshal.dump(self) )
  end


end