
require './app/market'
require './app/order_book_arber'
require 'httparty'

class ArbOpp
  attr_reader :market1, :market2, :gain, :potential_profit, :amount_to_arb, :arber

  def initialize(market1, market2)
    @market1 = market1
    @market2 = market2
    calc_gain
  end

  def calc_gain
    @gain = (@market2.bid_usd - @market1.ask_usd) / (@market1.ask_usd)
  end

  def calc_potential_profit
    begin
      @potential_profit, @amount_to_arb = 0.0, 0
      book1 = @market1.get_order_book
      book2 = @market2.get_order_book
      @arber = OrderBookArber.new(book1, book2)
      result = @arber.arb
      @potential_profit = result[:total_profit]
      @amount_to_arb = result[:amount_to_arb]
    rescue Net::OpenTimeout => e
      puts "timeout error on #{market1.name} (#{market1.exchange.name}-#{market2.exchange.name}), skipping"
    rescue StandardError => e
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