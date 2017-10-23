
require './app/livecoin_client'


RSpec.describe LivecoinClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      livecoin_client = LivecoinClient.new
      fixture = open("./spec/fixtures/livecoin_api_call.json").read;
      stub_request(:any, livecoin_client.url).to_return(body: fixture)
      
      exchange = livecoin_client.get_exchange()
      expect(exchange.name).to eq('livecoin')
      volume = 1035.08384668 * 0.00050001
      expected_crypto = CryptoPair.new(name: 'BNT-BTC', bid: 0.0002501, ask: 0.00064996, volume_24h: volume)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.cryptos[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end
end