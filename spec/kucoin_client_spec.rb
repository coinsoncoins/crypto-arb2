
require './app/kucoin_client'
require 'uri'


RSpec.describe KucoinClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      kucoin_client = KucoinClient.new
      fixture = open("./spec/fixtures/kucoin_api_call.json").read;
      stub_request(:any, kucoin_client.url).to_return(body: fixture)
      
      exchange = kucoin_client.get_exchange()
      expect(exchange.name).to eq('kucoin')
      expected_crypto = CryptoPair.new(name: 'KCS-BTC', bid: 0.000138, ask: 0.00013919, volume_24h: 287.93453001)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.crypto_pairs[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end

  context "#get_order_book" do
    it do
      kucoin_client = KucoinClient.new
      fixture = open("./spec/fixtures/kucoin_order_book.json").read;
      url_to_stub = kucoin_client.order_book_url.split('/')[2]
      stub_request(:any, Regexp.new(url_to_stub)).to_return(body: fixture)
      crypto_pair = CryptoPair.new(name: 'KCS-BTC')
      order_book = kucoin_client.get_order_book(crypto_pair)
      expect(order_book.bids.first.price).to eq(0.00013507)
      expect(order_book.bids.first.quantity).to eq(768.6678)
      expect(order_book.bids[1].price).to eq(0.00013506)
      expect(order_book.bids[1].quantity).to eq(70.7976)

      expect(order_book.asks.first.price).to eq(0.0001378)
      expect(order_book.asks.first.quantity).to eq(500.0)
      expect(order_book.asks[1].price).to eq(0.000138)
      expect(order_book.asks[1].quantity).to eq(29426.4375)
    end
  end
end