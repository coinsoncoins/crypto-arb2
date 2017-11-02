
require './app/etherdelta_client'


RSpec.describe EtherDeltaClient do
  before do
    stub_coinmarketcap_client
  end
  # context "#format_symbol" do
  #   it do 
  #     etherdelta_client = EtherDeltaClient.new
  #     expect(etherdelta_client.format_symbol("ETH_DOVU")).to eq("DOVU-ETH")
  #   end
  # end

  # context "#original_symbol" do
  #   it do 
  #     etherdelta_client = EtherDeltaClient.new
  #     expect(etherdelta_client.original_symbol("DOVU-ETH")).to eq("ETH_DOVU")
  #   end
  # end

  
  context "#get_exchange" do
    it "returns the exchange data" do
      etherdelta_client = EtherDeltaClient.new
      etherdelta_client.path_to_data = "./spec/fixtures/exchange_data/etherdelta"
      exchange = etherdelta_client.get_exchange()
      expect(exchange.name).to eq('etherdelta')
      expected_crypto = Market.new(name: 'PAY-ETH',
        bid: 0.00522, ask: 0.0054753)
      %i[name bid ask volume_24h bid_usd ask_usd].each do |value|
        expect(exchange.markets[0].send(value)).to eq(expected_crypto.send(value))
      end
    end
  end

  context do
    it do
      etherdelta_client = EtherDeltaClient.new
      exchange = etherdelta_client.get_exchange()
      exchange.markets[0]

    end
  end


  # context do
  #   it do
  #     require './app/etherdelta_client'
  #     client = EtherDeltaClient.new
  #     exchange = client.get_exchange
  #     market = exchange.markets[0]
  #     client.connect_socket
  #     client.request_order_book(market)
  #   end
  # end

  # context "#save_order_book_file" do
  #   it do
  #     data = JSON.parse(open("./file.json").read)
  #     client = EtherDeltaClient.new
  #     exchange = client.get_exchange
  #     client.save_order_book_file(data)
  #   end
  # end



  # context "#get_order_book" do
  #   before do
  #     stub_coinmarketcap_client
  #   end
  #   it do
  #     etherdelta_client = EtherDeltaClient.new
  #     fixture = open("./spec/fixtures/etherdelta_order_book.json").read
  #     url_to_stub = etherdelta_client.order_book_url.split('/')[2]
  #     stub_request(:any, Regexp.new(url_to_stub)).to_return(body: fixture)
  #     market = Market.new(name: 'MOD-ETH')
  #     order_book = etherdelta_client.get_order_book(market)
  #     expect(order_book.bids.first.price).to eq(0.00485)
  #     expect(order_book.bids.first.quantity).to eq(60)
  #     expect(order_book.bids[1].price).to eq(0.00481)
  #     expect(order_book.bids[1].quantity).to eq(1000)


  #     expect(order_book.asks.first.price).to eq(0.005)
  #     expect(order_book.asks.first.quantity).to eq(11)
  #     expect(order_book.asks[1].price).to eq(0.00502374)
  #     expect(order_book.asks[1].quantity).to eq(72)
  #   end
  # end
end