
require './app/cryptopia_client'


RSpec.describe CryptopiaClient do
  context "coin map" do
    it do
      
    end
  end

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

  context "#get_order_book" do
    it do
      cryptopia_client = CryptopiaClient.new
      fixture = open("./spec/fixtures/cryptopia_order_book.json").read;
      url_to_stub = cryptopia_client.order_book_url.split('/')[2]
      stub_request(:any, Regexp.new(url_to_stub)).to_return(body: fixture)
      crypto_pair = CryptoPair.new(name: 'NEBL-BTC')
      order_book = cryptopia_client.get_order_book(crypto_pair)
      expect(order_book.bids.first.price).to eq(0.00091851)
      expect(order_book.bids.first.quantity).to eq(12.51496879)
      expect(order_book.bids[1].price).to eq(0.00091020)
      expect(order_book.bids[1].quantity).to eq(48.00000000)

      expect(order_book.asks.first.price).to eq(0.00091856)
      expect(order_book.asks.first.quantity).to eq(0.38741341)
      expect(order_book.asks[1].price).to eq(0.00091857)
      expect(order_book.asks[1].quantity).to eq(29.60543026)
    end
  end
end