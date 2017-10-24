

require './app/exchange'

RSpec.describe Exchange do
  context "#has_crypto_pair?" do
    it do
      exchange = Exchange.new('bittrex', nil)
      crypto1 = CryptoPair.new(name: 'ZENBTC', bid: 0.00004186, ask: 0.00004188, volume_24h: 33.70546702)
      crypto2 = CryptoPair.new(name: 'VTCBTC', bid: 0.00004186, ask: 0.00004188, volume_24h: 33.70546702)
      exchange.add_crypto_pair(crypto1)
      exchange.add_crypto_pair(crypto2)
      
      expect(exchange.has_crypto_pair?(CryptoPair.new(name: 'ZENBTC'))).to be true
      expect(exchange.has_crypto_pair?(CryptoPair.new(name: 'VTCBTC'))).to be true
      expect(exchange.has_crypto_pair?(CryptoPair.new(name: 'REDDBTC'))).to be false
    end
  end
end

