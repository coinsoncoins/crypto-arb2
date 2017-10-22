
require './app/binance_client'


RSpec.describe BinanceClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      binance_client = BinanceClient.new
      fixture = open("./spec/fixtures/binance_api_call.json").read;
      stub_request(:any, binance_client.url).to_return(body: fixture)
      
      exchange = binance_client.get_exchange()
      expect(exchange.name).to eq('binance')
      expected_crypto = Crypto.new(name: 'ETHBTC', bid: 0.05041800, ask: 0.05050000, volume_24h: nil)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.cryptos[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end
end