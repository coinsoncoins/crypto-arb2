
require './app/arb_opp'
require './app/bittrex_client'


RSpec.describe ArbOpp do
  context "#calc_potential_profit" do
    before do
      stub_coinmarketcap_client
    end

    it do
      bittrex_client = BittrexClient.new
      hitbtc_client = HitBtcClient.new
      fixture = open("./spec/fixtures/bittrex_order_book_bnt.json").read;
      stub_request(:any, Regexp.new(bittrex_client.order_book_url.split('/')[2])).to_return(body: fixture)
      fixture = open("./spec/fixtures/hitbtc_order_book_bnt.json").read;
      stub_request(:any, Regexp.new(hitbtc_client.order_book_url.split('/')[2])).to_return(body: fixture)

      crypto_pair1 = CryptoPair.new(name: 'BNT-BTC', exchange: bittrex_client.exchange)
      crypto_pair2 = CryptoPair.new(name: 'BNT-BTC', exchange: hitbtc_client.exchange)

      arb_opp = ArbOpp.new(crypto_pair1, crypto_pair2)
      expect(arb_opp.calc_potential_profit).to be_within(0.0000001).of(0.00002464)
    end
  end
end
