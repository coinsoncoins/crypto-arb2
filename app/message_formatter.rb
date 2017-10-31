require './app/currency_converter'

class MessageFormatter

  def self.arb_opp(arb_opp)
    "Buy #{arb_opp.market1.name} at #{arb_opp.market1.exchange.name} at ask #{'%.8f' % arb_opp.market1.ask} " \
    "($#{arb_opp.market1.ask_usd}) (volume #{arb_opp.market1.volume_24h}) " \
    "and sell #{arb_opp.market2.name} at #{arb_opp.market2.exchange.name} at bid #{'%.8f' % arb_opp.market2.bid} " \
    "($#{arb_opp.market2.bid_usd}) (volume #{arb_opp.market2.volume_24h}) for gain #{arb_opp.gain_percent.round(1)}%. " \
    "potential profit=$#{'%.2f' % arb_opp.potential_profit}.  Buy #{arb_opp.amount_to_arb} coins " \
    "($#{'%.2f' % (arb_opp.market1.ask_usd * arb_opp.amount_to_arb)})"
  end

end