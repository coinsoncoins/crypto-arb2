
require './app/bittrex_client'


RSpec.describe BittrexClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      bittrex_client = BittrexClient.new
      fixture = open("./spec/fixtures/bittrex_api_call.json").read;
      stub_request(:any, bittrex_client.url).to_return(body: fixture)
      
      exchange = bittrex_client.get_exchange()
      expect(exchange.name).to eq('bittrex')
      expected_crypto = CryptoPair.new(name: '1STBTC', bid: 0.00004186, ask: 0.00004188, volume_24h: 33.70546702)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.cryptos[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end
end