
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

  # context "#get_order_book" do
  #   it do
  #     kucoin_client = BittrexClient.new
  #     fixture = open("./spec/fixtures/bittrex_order_book.json").read;
  #     url_to_stub = URI.parse(kucoin_client.order_book_url).host
  #     stub_request(:any, Regexp.new(url_to_stub)).to_return(body: fixture)
  #     crypto_pair = CryptoPair.new(name: 'NAV-BTC')
  #     order_book = kucoin_client.get_order_book(crypto_pair)
  #     expect(order_book.bids.first.price).to eq(0.00013094)
  #     expect(order_book.bids.first.quantity).to eq(20.00000000)
  #     expect(order_book.bids[1].price).to eq(0.00013048)
  #     expect(order_book.bids[1].quantity).to eq(321.93063748)

  #     expect(order_book.asks.first.price).to eq(0.00013100)
  #     expect(order_book.asks.first.quantity).to eq(2192.89256411)
  #     expect(order_book.asks[1].price).to eq(0.00013114)
  #     expect(order_book.asks[1].quantity).to eq(122.02651667)
  #   end
  # end
end