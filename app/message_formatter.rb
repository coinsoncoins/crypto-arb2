require './app/currency_converter'

class MessageFormatter

  def self.arb_opp(arb_opp)
    output = "Buy #{arb_opp.market1.name} at #{arb_opp.market1.exchange.name} at ask #{'%.8f' % arb_opp.market1.ask} " \
    "($#{arb_opp.market1.ask_usd}) (volume #{arb_opp.market1.volume_24h}) " \
    "and sell #{arb_opp.market2.name} at #{arb_opp.market2.exchange.name} at bid #{'%.8f' % arb_opp.market2.bid} " \
    "($#{arb_opp.market2.bid_usd}) (volume #{arb_opp.market2.volume_24h}) for gain #{arb_opp.gain_percent.round(1)}%. " \
    "potential profit=$#{'%.2f' % arb_opp.potential_profit}.  Buy #{arb_opp.amount_to_arb} coins " \
    "($#{'%.2f' % (arb_opp.market1.ask_usd * arb_opp.amount_to_arb)})\n"

    if arb_opp.arber
      arb_opp.arber.transactions.each do |transaction|
        output += transaction.to_s + "\n"
      end
    end
    output
  end

  def self.to_telegram(arb_opps)
    message = ''
    arb_opps.each do |arb_opp|
      message += "#{arb_opp.market1.name} (#{arb_opp.market1.exchange.name}) - #{arb_opp.market2.name} (#{arb_opp.market2.exchange.name}) " \
      "$#{('%.2f' % arb_opp.potential_profit)}\n"
    end
    message
  end

end