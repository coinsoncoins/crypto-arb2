
require "./app/binance_client"
require "./app/bittrex_client"
require './app/market_comparer'

bittrex_markets = BittrexClient.new.get_snapshot()
binance_markets = BinanceClient.new.get_snapshot()

result = MarketComparer.compare(bittrex_markets, binance_markets)
puts JSON.pretty_generate(result)