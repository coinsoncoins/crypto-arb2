
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

  context "#get_order_book" do
    it do
      hitbtc_client = HitBtcClient.new
      fixture = open("./spec/fixtures/hitbtc_order_book.json").read;
      url_to_stub = hitbtc_client.order_book_url.split('/')[2]
      stub_request(:any, Regexp.new(url_to_stub)).to_return(body: fixture)
      crypto_pair = CryptoPair.new(name: 'DASH-BTC')
      order_book = hitbtc_client.get_order_book(crypto_pair)
      expect(order_book.bids.first.price).to eq(0.051275)
      expect(order_book.bids.first.quantity).to eq(0.007)
      expect(order_book.bids[1].price).to eq(0.051169)
      expect(order_book.bids[1].quantity).to eq(5.000)

      expect(order_book.asks.first.price).to eq(0.051373)
      expect(order_book.asks.first.quantity).to eq(0.001)
      expect(order_book.asks[1].price).to eq(0.051374)
      expect(order_book.asks[1].quantity).to eq(2.292)
    end
  end
end

