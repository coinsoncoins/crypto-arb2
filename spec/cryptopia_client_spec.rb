
require './app/cryptopia_client'


RSpec.describe CryptopiaClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      cryptopia_client = CryptopiaClient.new
      fixture = open("./spec/fixtures/cryptopia_api_call.json").read;
      stub_request(:any, cryptopia_client.url).to_return(body: fixture)
      
      exchange = cryptopia_client.get_exchange()
      expect(exchange.name).to eq('cryptopia')
      expected_crypto = CryptoPair.new(name: '$$$-BTC', bid: 0.00000019, ask: 0.00000021, volume_24h: 0.07167655)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.crypto_pairs[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end
end