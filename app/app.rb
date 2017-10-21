
require "./app/binance_client"
require "./app/bittrex_client"
require './app/hitbtc_client'
require './app/market_comparer'

bittrex_markets = BittrexClient.new.get_snapshot()
binance_markets = BinanceClient.new.get_snapshot()
hittbc_markets = HitBtcClient.new.get_snapshot()

puts 'bittrex / binance'
result = MarketComparer.compare(bittrex_markets, binance_markets)
puts JSON.pretty_generate(result)

puts 'bittrex / hitbtc'
result = MarketComparer.compare(bittrex_markets, hittbc_markets)
puts JSON.pretty_generate(result)

puts 'binance / hitbtc'
result = MarketComparer.compare(binance_markets, hittbc_markets)
puts JSON.pretty_generate(result)


