require './app/coinmarketcap_client'
require './app/currency_converter'


RSpec.describe CurrencyConverter do
  before do
    stub_coinmarketcap_client
  end
  context "methods" do
    it do
      expect(CurrencyConverter.BTCUSD).to eq(6000)
      expect(CurrencyConverter.ETHUSD).to eq(300)
    end
  end

  context "convert" do
    it do
      expect(CurrencyConverter.btc_to_eth(1)).to eq(20)
      expect(CurrencyConverter.eth_to_btc(1)).to eq(0.05)
      expect(CurrencyConverter.btc_to_usd(1)).to eq(6000)
      expect(CurrencyConverter.eth_to_usd(1)).to eq(300)
    end
  end
end