
require './app/market'

class ArbOpp
  attr_reader :market1, :market2, :gain, :potential_profit, :amount_to_arb

  def initialize(market1, market2)
    @market1 = market1
    @market2 = market2
    calc_gain
  end

  def calc_gain
    @gain = (@market2.bid - @market1.ask) / (@market1.ask)
  end

  def calc_potential_profit
    begin
      book1 = @market1.get_order_book
      book2 = @market2.get_order_book
      result = OrderBook.arb_order_books(book1, book2)
      @potential_profit = result[:total_profit]
      @amount_to_arb = result[:amount_to_arb]
    rescue RuntimeError => e
      @potential_profit, @amount_to_arb = 0.0, 0
      puts e
    end
    @potential_profit
  end

  def gain_percent
    @gain * 100.0
  end

  def crypto_name
    @market1.name
  end

  def valid?()
    @market1.valid? && @market2.valid?
  end

end