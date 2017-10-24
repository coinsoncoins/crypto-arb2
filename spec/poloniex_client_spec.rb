
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
        expect(exchange.crypto_pairs[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end

  context "#get_order_book" do
    it do
      poloniex_client = PoloniexClient.new
      fixture = open("./spec/fixtures/poloniex_order_book.json").read;
      url_to_stub = poloniex_client.order_book_url.split('/')[2]
      stub_request(:any, Regexp.new(url_to_stub)).to_return(body: fixture)
      crypto_pair = CryptoPair.new(name: 'VTC-BTC')
      order_book = poloniex_client.get_order_book(crypto_pair)
      expect(order_book.bids.first.price).to eq(0.00062101)
      expect(order_book.bids.first.quantity).to eq(56.34369817)
      expect(order_book.bids[1].price).to eq(0.00062100)
      expect(order_book.bids[1].quantity).to eq(170.40206119)

      expect(order_book.asks.first.price).to eq(0.00062997)
      expect(order_book.asks.first.quantity).to eq(435.6145382)
      expect(order_book.asks[1].price).to eq(0.00063000)
      expect(order_book.asks[1].quantity).to eq(231.93246281)
    end
  end
end