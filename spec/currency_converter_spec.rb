
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
end