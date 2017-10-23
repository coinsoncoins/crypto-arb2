
require './app/currency_converter'


RSpec.describe CurrencyConverter do
  context "#get_quotes" do
    it do
      fixture = open("./spec/fixtures/coinmarketcap_tickers.json").read;
      stub_request(:any, CurrencyConverter.api_url).to_return(body: fixture)
      CurrencyConverter.get_quotes()
      expect(CurrencyConverter.BTCUSD).to eq(5914.45)
      expect(CurrencyConverter.ETHUSD).to eq(293.401)
    end
  end

  context "#eth_to_usd" do
    it do
      expect(CurrencyConverter.btc_to_eth(1)).to eq(20.158247586068214)
      expect(CurrencyConverter.eth_to_btc(1)).to eq(0.04960748674855651)
    end
  end
end