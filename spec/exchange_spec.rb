

require './app/exchange'

RSpec.describe Exchange do
  context "#has_market?" do
    it do
      exchange = Exchange.new('bittrex', nil)
      crypto1 = Market.new(name: 'ZENBTC', bid: 0.00004186, ask: 0.00004188, volume_24h: 33.70546702)
      crypto2 = Market.new(name: 'VTCBTC', bid: 0.00004186, ask: 0.00004188, volume_24h: 33.70546702)
      exchange.add_market(crypto1)
      exchange.add_market(crypto2)
      
      expect(exchange.has_market?(Market.new(name: 'ZENBTC'))).to be true
      expect(exchange.has_market?(Market.new(name: 'VTCBTC'))).to be true
      expect(exchange.has_market?(Market.new(name: 'REDDBTC'))).to be false
    end
  end
end

