class ExchangeCompareResultsFormatter

  def self.format(results)
    "Buy #{results.market} at #{results.exchange1} at ask #{results.ask1} (volume #{results.volume1}) " \
    "and sell at #{results.exchange2} at bid #{results.bid2} (volume #{results.volume2}) for gain #{(results.gain*100.0).round}%"
  end

end