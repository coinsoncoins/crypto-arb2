require './app/liqui_client'
require 'uri'


RSpec.describe LiquiClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      liqui_client = LiquiClient.new
      fixture = open("./spec/fixtures/liqui_api_call.json").read;
      stub_request(:any, Regexp.new(liqui_client.url)).to_return(body: fixture)
      trade_pair_fixture = open("./spec/fixtures/liqui_pair_info.json").read
      stub_request(:any, liqui_client.trade_pairs_url).to_return(body: trade_pair_fixture)

     
      
      exchange = liqui_client.get_exchange()
      expect(exchange.name).to eq('liqui')
      expected_crypto = CryptoPair.new(name: 'LTCBTC', bid: 0.0097081, ask: 0.00973799, volume_24h: 49.682074394008394)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.cryptos[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end
end