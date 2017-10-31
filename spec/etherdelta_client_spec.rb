
require './app/etherdelta_client'


RSpec.describe EtherDeltaClient do
  context "#get_exchange" do
    it "returns the exchange data" do
      etherdelta_client = EtherDeltaClient.new
      fixture = open("./spec/fixtures/etherdelta_market_summaries.json").read
      stub_request(:any, etherdelta_client.url).to_return(body: fixture)
      
      exchange = etherdelta_client.get_exchange()
      expect(exchange.name).to eq('etherdelta')
      expected_crypto = CryptoPair.new(name: 'MOD-ETH', token_addr: "0x957c30ab0426e0c93cd8241e2c60392d08c6ac8e", 
        bid: 0.00485, ask: 0.005, volume_24h: 2564.891)
      %i[name bid ask volume_24h token_addr].each do |value|
        expect(exchange.crypto_pairs[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end

  context "#get_order_book" do
    before do
      stub_coinmarketcap_client
    end
    it do
      etherdelta_client = EtherDeltaClient.new
      fixture = open("./spec/fixtures/etherdelta_order_book.json").read
      url_to_stub = etherdelta_client.order_book_url.split('/')[2]
      stub_request(:any, Regexp.new(url_to_stub)).to_return(body: fixture)
      crypto_pair = CryptoPair.new(name: 'MOD-ETH')
      order_book = etherdelta_client.get_order_book(crypto_pair)
      expect(order_book.bids.first.price).to eq(0.00485)
      expect(order_book.bids.first.quantity).to eq(60)
      expect(order_book.bids[1].price).to eq(0.00481)
      expect(order_book.bids[1].quantity).to eq(1000)


      expect(order_book.asks.first.price).to eq(0.005)
      expect(order_book.asks.first.quantity).to eq(11)
      expect(order_book.asks[1].price).to eq(0.00502374)
      expect(order_book.asks[1].quantity).to eq(72)
    end
  end
end