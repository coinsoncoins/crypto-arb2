
require './app/coinexchange_client'


RSpec.describe CoinExchangeClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      coinexchange_client = CoinExchangeClient.new
      fixture = open("./spec/fixtures/coinexchange_market_summaries.json").read
      stub_request(:any, coinexchange_client.url).to_return(body: fixture)
      fixture = open('./spec/fixtures/coinexchange_markets.json').read
      stub_request(:any, coinexchange_client.markets_url).to_return(body: fixture)
      
      exchange = coinexchange_client.get_exchange()
      expect(exchange.name).to eq('coinexchange')
      expected_crypto = CryptoPair.new(name: 'LTC-BTC', bid: 0.00910000, ask: 0.00924960, volume_24h: 3.75324688)
      %i[name bid ask volume_24h].each do |value|
        expect(exchange.crypto_pairs[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end

  context "#get_order_book" do
    before do
      stub_coinmarketcap_client
    end
    it do
      coinexchange_client = CoinExchangeClient.new
      fixture = open("./spec/fixtures/coinexchange_order_book.json").read
      url_to_stub = coinexchange_client.order_book_url.split('/')[2]
      stub_request(:any, Regexp.new(url_to_stub)).to_return(body: fixture)
      crypto_pair = CryptoPair.new(name: 'LTC-BTC')
      order_book = coinexchange_client.get_order_book(crypto_pair)
      expect(order_book.bids.first.price).to eq(0.00915000)
      expect(order_book.bids.first.quantity).to eq(0.03194737)
      expect(order_book.bids[1].price).to eq(0.00910000)
      expect(order_book.bids[1].quantity).to eq(19.97168134)

      expect(order_book.asks.first.price).to eq(0.00924970)
      expect(order_book.asks.first.quantity).to eq(0.05383262)
      expect(order_book.asks[1].price).to eq(0.00924978)
      expect(order_book.asks[1].quantity).to eq(1.85548728)
    end
  end
end