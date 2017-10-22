
require './app/arb_opp'

class ArbFinder
  attr_reader :arb_opps
  def initialize(exchange1, exchange2)
    @arb_opps = []
    @exchange1 = exchange1
    @exchange2 = exchange2
  end


  def compare
    @exchange1.cryptos.each do |crypto1|
      if @exchange2.has_crypto?(crypto1)
        crypto2 = @exchange2.get_crypto_like(crypto1)
        arb_opp = ArbOpp.new(crypto1, crypto2)
        @arb_opps.push(arb_opp)
      end
    end
    @arb_opps.sort_by { |a| a.gain }.reverse
  end


end