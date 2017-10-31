require './app/kraken_client'
require 'uri'


RSpec.describe KrakenClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      kraken_client = KrakenClient.new
      fixture = open("./spec/fixtures/kraken_api_call.json").read;
      stub_request(:any, Regexp.new(URI.parse(kraken_client.url).host)).to_return(body: fixture)
      trade_pair_fixture = open("./spec/fixtures/kraken_pair_info.json").read
      stub_request(:any, kraken_client.trade_pairs_url).to_return(body: trade_pair_fixture)
      
      exchange = kraken_client.get_exchange()
      expect(exchange.name).to eq('kraken')
      expected_crypto = Market.new(name: 'BCH-EUR', bid: 283.500000, ask: 286.200000, volume_24h: 2995.54482595)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.markets[0].send(value)).to eq(expected_crypto.send(value))
      end
      # make sure altnames work + make sure XBT is converted to BTC
      expected_crypto = Market.new(name: 'ICN-BTC', bid: 0.000192, ask: 0.000194, volume_24h: 123018.32824442)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.markets[22].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end
end