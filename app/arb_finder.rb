
require './app/arb_opp'

class ArbFinder
  attr_reader :arb_opps

  ARB_THRESHOLD_PERCENT = 1.0

  def initialize(exchange1, exchange2)
    @arb_opps = []
    @exchange1 = exchange1
    @exchange2 = exchange2
  end


  def compare
    @exchange1.markets.each do |market1|
      markets_to_compare = @exchange2.get_markets_for_crypto(market1.crypto)

      if @exchange2.has_market?(market1)
        market2 = @exchange2.get_market_like(market1)
        arb_opp = ArbOpp.new(market1, market2)
        puts "#{market1.name} on both #{market1.exchange.name} and #{market2.exchange.name} with percent_diff #{'%.1f' % arb_opp.gain_percent}%"
        if arb_opp.gain_percent > ARB_THRESHOLD_PERCENT && arb_opp.valid?
          arb_opp.calc_potential_profit
          @arb_opps.push(arb_opp)
        end
      end
    end
    @arb_opps.sort_by { |a| a.gain }.reverse
  end


end