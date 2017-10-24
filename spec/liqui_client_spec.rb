require './app/liqui_client'
require 'uri'


RSpec.describe LiquiClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      liqui_client = LiquiClient.new
      fixture = open("./spec/fixtures/liqui_api_call.json").read;
      stub_request(:any, Regexp.new(liqui_client.url)).to_return(body: fixture)
      trade_pair_fixture = open("./spec/fixtures/liqui_pair_info.json").read
      stub_request(:any, liqui_client.trade_pairs_url).to_return(body: trade_pair_fixture)

      exchange = liqui_client.get_exchange()
      expect(exchange.name).to eq('liqui')
      expected_crypto = CryptoPair.new(name: 'LTC-BTC', bid: 0.0097081, ask: 0.00973799, volume_24h: 49.682074394008394)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.crypto_pairs[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end

  context "#get_order_book" do
    it do
      liqui_client = LiquiClient.new
      fixture = open("./spec/fixtures/liqui_order_book.json").read;
      url_to_stub = liqui_client.order_book_url.split('/')[2]
      stub_request(:any, Regexp.new(url_to_stub)).to_return(body: fixture)
      crypto_pair = CryptoPair.new(name: 'AST-BTC')
      order_book = liqui_client.get_order_book(crypto_pair)
      expect(order_book.bids.first.price).to eq(0.00003991)
      expect(order_book.bids.first.quantity).to eq(149.34894156)
      expect(order_book.bids[1].price).to eq(0.00003988)
      expect(order_book.bids[1].quantity).to eq(200.0)

      expect(order_book.asks.first.price).to eq(0.00004019)
      expect(order_book.asks.first.quantity).to eq(124.14)
      expect(order_book.asks[1].price).to eq(0.00004021)
      expect(order_book.asks[1].quantity).to eq(328.29072933)
    end
  end
end