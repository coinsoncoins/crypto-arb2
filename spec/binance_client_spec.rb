
require './app/binance_client'


RSpec.describe BinanceClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      binance_client = BinanceClient.new
      fixture = open("./spec/fixtures/binance_api_call.json").read;
      stub_request(:any, binance_client.url).to_return(body: fixture)
      
      exchange = binance_client.get_exchange()
      expect(exchange.name).to eq('binance')
      expected_crypto = CryptoPair.new(name: 'ETH-BTC', bid: 0.05041800, ask: 0.05050000, volume_24h: nil)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.crypto_pairs[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end

  context "#get_order_book" do
    it do
      binance_client = BinanceClient.new
      fixture = open("./spec/fixtures/binance_order_book.json").read;
      url_to_stub = binance_client.order_book_url.split('/')[2]
      stub_request(:any, Regexp.new(url_to_stub)).to_return(body: fixture)
      crypto_pair = CryptoPair.new(name: 'SUB-BTC')
      order_book = binance_client.get_order_book(crypto_pair)
      expect(order_book.bids.first.price).to eq(0.00002660)
      expect(order_book.bids.first.quantity).to eq(30847.00000000)
      expect(order_book.bids[1].price).to eq(0.00002624)
      expect(order_book.bids[1].quantity).to eq(2526.00000000)

      expect(order_book.asks.first.price).to eq(0.00002701)
      expect(order_book.asks.first.quantity).to eq(6664.00000000)
      expect(order_book.asks[1].price).to eq(0.00002702)
      expect(order_book.asks[1].quantity).to eq(423.00000000)
    end
  end
end