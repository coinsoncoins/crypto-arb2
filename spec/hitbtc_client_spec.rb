
require './app/hitbtc_client'

RSpec.describe HitBtcClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      hitbtc_client = HitBtcClient.new

      fixture = open("./spec/fixtures/hitbtc_api_call.json").read;
      stub_request(:any, hitbtc_client.url).to_return(body: fixture)

      exchange = hitbtc_client.get_exchange()
      expect(exchange.name).to eq('hitbtc')
      expected_crypto = CryptoPair.new(name: 'BCN-BTC', bid: 0.0000002501, ask: 0.0000002504, volume_24h: 206.80351967)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.crypto_pairs[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end
end

