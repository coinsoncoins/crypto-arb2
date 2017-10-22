class MessageFormatter

  def self.arb_opp(arb_opp)
    "Buy #{arb_opp.crypto_name} at #{arb_opp.exchange1.name} at ask #{'%.8f' % arb_opp.ask1} (volume #{arb_opp.volume_24h1}) " \
    "and sell at #{arb_opp.exchange2.name} at bid #{'%.8f' % arb_opp.bid2} (volume #{arb_opp.volume_24h2}) for gain #{arb_opp.gain_percent.round(1)}%"
  end

end