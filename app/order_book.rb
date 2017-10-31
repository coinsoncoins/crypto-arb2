require './app/order_book_entry'
require "active_support/hash_with_indifferent_access"

class OrderBook
  attr_reader :book, :market

  def initialize(market)
    @book = ActiveSupport::HashWithIndifferentAccess.new({bid: [], ask: []})
    @has_been_ordered = false
    @market = market
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
    @book[side].push(OrderBookEntry.new(quantity: quantity.to_f, price: price.to_f, side: side, order_book: self))
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

  def self.arb_order_books(book1, book2)
    book1.verify_ordered()
    book2.verify_ordered()
    total_profit, amount_to_arb = 0.0, 0
    book1, book2 = book1.deep_clone, book2.deep_clone
    while true
      lowest_ask = book1.asks.first
      highest_bid = book2.bids.first
      break if !lowest_ask or !highest_bid
      min_quantity = [lowest_ask.quantity, highest_bid.quantity].min
      # execute the sale
      lowest_ask.quantity -= min_quantity
      highest_bid.quantity -= min_quantity
      profit = min_quantity * (highest_bid.price_usd - lowest_ask.price_usd)
      break if profit <= 0
      book1.asks.shift if lowest_ask.quantity <= 0.0001
      book2.bids.shift if highest_bid.quantity <= 0.0001
      total_profit += profit
      amount_to_arb += min_quantity
      puts "buying #{min_quantity} at #{highest_bid.price_usd} and selling at #{lowest_ask.price_usd} for profit #{profit} and total profit #{total_profit}"
    end
    {total_profit: total_profit, amount_to_arb: amount_to_arb}
  end

  def deep_clone()
    Marshal.load( Marshal.dump(self) )
  end


end