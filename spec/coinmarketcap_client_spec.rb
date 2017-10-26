
require './app/coinmarketcap_client'


RSpec.describe CoinMarketCapClient do
  it do
    fixture = open("./spec/fixtures/coinmarketcap_tickers.json").read;
    stub_request(:any, CoinMarketCapClient.url).to_return(body: fixture)
    expect(CoinMarketCapClient.get_price_usd('bitcoin')).to eq(6000)
    expect(CoinMarketCapClient.get_price_usd('dash')).to eq(274.53)
  end

end