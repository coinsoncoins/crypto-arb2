
require './app/poloniex_client'


RSpec.describe PoloniexClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      poloniex_client = PoloniexClient.new
      fixture = open("./spec/fixtures/poloniex_api_call.json").read;
      stub_request(:any, poloniex_client.url).to_return(body: fixture)
      
      exchange = poloniex_client.get_exchange()
      expect(exchange.name).to eq('poloniex')
      expected_crypto = CryptoPair.new(name: 'BCN-BTC', bid: 0.00000024, ask: 0.00000025, volume_24h: 19.37260896)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.cryptos[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end
end