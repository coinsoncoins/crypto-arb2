
require './app/bittrex_client'
require 'uri'


RSpec.describe BittrexClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      bittrex_client = BittrexClient.new
      fixture = open("./spec/fixtures/bittrex_api_call.json").read;
      stub_request(:any, bittrex_client.url).to_return(body: fixture)
      
      exchange = bittrex_client.get_exchange()
      expect(exchange.name).to eq('bittrex')
      expected_crypto = CryptoPair.new(name: '1ST-BTC', bid: 0.00004186, ask: 0.00004188, volume_24h: 33.70546702)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.crypto_pairs[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end

  context "#get_order_book" do
    it do
      bittrex_client = BittrexClient.new
      fixture = open("./spec/fixtures/bittrex_order_book.json").read;
      url_to_stub = URI.parse(bittrex_client.order_book_url).host
      stub_request(:any, Regexp.new(url_to_stub)).to_return(body: fixture)
      crypto_pair = CryptoPair.new(name: 'NAV-BTC')
      order_book = bittrex_client.get_order_book(crypto_pair)
      expect(order_book.bids.first.price).to eq(0.00013094)
      expect(order_book.bids.first.quantity).to eq(20.00000000)
      expect(order_book.bids[1].price).to eq(0.00013048)
      expect(order_book.bids[1].quantity).to eq(321.93063748)

      expect(order_book.asks.first.price).to eq(0.00013100)
      expect(order_book.asks.first.quantity).to eq(2192.89256411)
      expect(order_book.asks[1].price).to eq(0.00013114)
      expect(order_book.asks[1].quantity).to eq(122.02651667)
    end
  end
end