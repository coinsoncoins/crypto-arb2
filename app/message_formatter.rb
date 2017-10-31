require './app/currency_converter'

class MessageFormatter

  def self.arb_opp(arb_opp)
    #return if potential_profit == 0
    potential_profit_dollars = CurrencyConverter.btc_to_usd(arb_opp.potential_profit)
    "Buy #{arb_opp.market1.name} at #{arb_opp.market1.exchange.name} at ask #{'%.8f' % arb_opp.market1.ask} (volume #{arb_opp.market1.volume_24h}) " \
    "and sell at #{arb_opp.market2.exchange.name} at bid #{'%.8f' % arb_opp.market2.bid} (volume #{arb_opp.market2.volume_24h}) for gain #{arb_opp.gain_percent.round(1)}%. " \
    "potential profit=#{'%.8f' % arb_opp.potential_profit} BTC ($#{potential_profit_dollars.round})"
  end

end