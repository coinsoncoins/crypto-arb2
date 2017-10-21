require 'ostruct'

class ExchangeComparer
  def self.compare(exchange1, exchange2)

    results = []
    exchange1[:markets].each do |market, market_data|
      #next if exchange1.markets[market][:ask] == 0
      if exchange2[:markets].key?(market)
        result = OpenStruct.new
        result.market = market.to_s
        result.exchange1 = exchange1[:name]
        result.exchange2 = exchange2[:name]
        result.ask1 = exchange1[:markets][market][:ask].to_f
        result.bid1 = exchange1[:markets][market][:bid].to_f
        result.volume1 = exchange1[:markets][market][:volume]
        result.ask2 = exchange2[:markets][market][:ask].to_f
        result.bid2 = exchange2[:markets][market][:bid].to_f
        result.volume2 = exchange2[:markets][market][:volume]
        result.gain = (result.bid2 - result.ask1) / result.ask1
        results.push(result)
      end
    end
    results
  end
end
