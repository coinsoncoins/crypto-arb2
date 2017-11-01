
require './app/exchange'
require './app/market'
require './app/market_ignore'

RSpec.describe MarketIgnore do
  context "" do
    before do
      stub_coinmarketcap_client
    end
    it do
      exchange = Exchange.new('cryptopia', nil)
      market = Market.new(name: 'QTUM-BTC', exchange: exchange)
      expect(MarketIgnore.ignore?(market)).to be(true)
    end

    it 'doesnt crash if we use an exchange that doesnt exist' do
      exchange = Exchange.new('this exchange doesnt exist!!!', nil)
      market = Market.new(name: 'QTUM-BTC', exchange: exchange)
      expect(MarketIgnore.ignore?(market)).to be(false)
    end
  end
end
