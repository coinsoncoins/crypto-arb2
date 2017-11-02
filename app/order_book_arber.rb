
require './app/order_book'
require './app/arb_transaction'

class OrderBookArber
  attr_reader :book1, :book2, :transactions
  def initialize(book1, book2)
    @book1 = book1
    @book2 = book2
    @transactions = []
  end

  def arb()
    @book1.verify_ordered()
    @book2.verify_ordered()
    total_profit, amount_to_arb = 0.0, 0
    book1, book2 = @book1.deep_clone, @book2.deep_clone
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
      @transactions.push(ArbTransaction.new(buy_at: highest_bid.price_usd, sell_at: lowest_ask.price_usd, 
        quantity: min_quantity, profit: profit, total_profit: total_profit))
      puts "buying #{min_quantity} at #{highest_bid.price_usd} and selling at #{lowest_ask.price_usd} for profit #{profit} and total profit #{total_profit}"
    end
    {total_profit: total_profit, amount_to_arb: amount_to_arb}
  end
end