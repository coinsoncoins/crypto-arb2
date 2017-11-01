

class MarketIgnore

  class << self
    def ignore?(market)
      return data[market.exchange.name].include?(market.name) if data[market.exchange.name]
      false
    end


    def data
      @data ||= JSON.parse(open("./app/data/coin_config.json").read)["marketsToIgnore"]
    end
  end

end