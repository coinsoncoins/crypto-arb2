
require './app/arb_opp'
require './app/market_ignore'

class ArbFinder
  attr_reader :arb_opps

  ARB_THRESHOLD_PERCENT = 0.0

  def initialize(exchange1, exchange2)
    @arb_opps = []
    @exchange1 = exchange1
    @exchange2 = exchange2
  end


  def compare
    @exchange1.markets.each do |market1|
      next if MarketIgnore.ignore?(market1)
      markets_to_compare = @exchange2.get_all_markets_for_crypto(market1.crypto)
      markets_to_compare.each do |market2|
        next if MarketIgnore.ignore?(market2)
        next if market1 == market2
        next if !supported_base?(market1) || !supported_base?(market2)
        puts "checking arb_opps #{market1.name} at #{market1.exchange.name} to #{market2.name} at #{market2.exchange.name}"
        arb_opp = ArbOpp.new(market1, market2)
        if arb_opp.gain_percent > ARB_THRESHOLD_PERCENT && arb_opp.valid?
          puts arb_opp.gain_percent
          arb_opp.calc_potential_profit
          @arb_opps.push(arb_opp)
        end
      end
      # if @exchange2.has_market?(market1)
      #   market2 = @exchange2.get_market_like(market1)
      #   arb_opp = ArbOpp.new(market1, market2)
      #   puts "#{market1.name} on both #{market1.exchange.name} and #{market2.exchange.name} with percent_diff #{'%.1f' % arb_opp.gain_percent}%"
      #   if arb_opp.gain_percent > ARB_THRESHOLD_PERCENT && arb_opp.valid?
      #     arb_opp.calc_potential_profit
      #     @arb_opps.push(arb_opp)
      #   end
      # end
    end
    @arb_opps.sort_by { |a| a.potential_profit }.reverse
  end

  def supported_base?(market)
    %w[BTC ETH].include?(market.base)
  end

end