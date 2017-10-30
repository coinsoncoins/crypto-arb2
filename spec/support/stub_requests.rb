
require './app/coinmarketcap_client'

def stub_coinmarketcap_client()
  fixture = open("./spec/fixtures/coinmarketcap_tickers.json").read;
  stub_request(:any, CoinMarketCapClient.url).to_return(body: fixture)
end
