
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
    @exchange1.crypto_pairs.each do |crypto1|
      if @exchange2.has_crypto_pair?(crypto1)
        crypto2 = @exchange2.get_crypto_pair_like(crypto1)
        arb_opp = ArbOpp.new(crypto1, crypto2)
        puts "#{crypto1.name} on both #{crypto1.exchange.name} and #{crypto2.exchange.name} with percent_diff #{'%.1f' % arb_opp.gain_percent}%"
        if arb_opp.gain_percent > ARB_THRESHOLD_PERCENT && arb_opp.valid?
          arb_opp.calc_potential_profit
          @arb_opps.push(arb_opp)
        end
      end
    end
    @arb_opps.sort_by { |a| a.gain }.reverse
  end


end