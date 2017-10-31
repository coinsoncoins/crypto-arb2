
require './app/market'

class ArbOpp
  attr_reader :market1, :market2, :exchange1, :ask1, :volume_24h1, :exchange2, :bid2, :volume_24h2,
    :gain, :potential_profit, :amount_to_arb

  def initialize(market1, market2)
    @market1 = market1
    @market2 = market2
    @exchange1 = market1.exchange
    @ask1 = market1.ask
    @volume_24h1 = market1.volume_24h
    @exchange2 = market2.exchange
    @bid2 = market2.bid
    @volume_24h2 = market2.volume_24h
    @gain = (@bid2 - @ask1) / (@ask1)
  end

  def calc_potential_profit
    begin
      book1 = @market1.get_order_book
      book2 = @market2.get_order_book
      result = book1.arb_order_books(book2)
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