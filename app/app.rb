
require "./app/binance_client"
require "./app/bittrex_client"
require './app/hitbtc_client'
require './app/arb_finder'
require './app/arb_opp'
require './app/message_formatter'


def main()

  bittrex_exchange = BittrexClient.new.get_exchange()
  #binance_markets = BinanceClient.new.get_snapshot()
  hitbtc_exchange = HitBtcClient.new.get_exchange()

  puts 'bittrex / hitbtc'
  arb_opps = ArbFinder.new(bittrex_exchange, hitbtc_exchange).compare
  arb_opps.each do |arp_opp|
    puts MessageFormatter.arb_opp(arp_opp)
  end

  puts 
  puts 'hitbtc / bittrex'
  arb_opps = ArbFinder.new(hitbtc_exchange, bittrex_exchange).compare
  arb_opps.each do |arp_opp|
    puts MessageFormatter.arb_opp(arp_opp)
  end

end

# puts 'bittrex / binance'
# result = MarketComparer.compare(bittrex_markets, binance_markets)
# puts JSON.pretty_generate(result)

# puts 'binance / hitbtc'
# result = MarketComparer.compare(binance_markets, hittbc_markets)
# puts JSON.pretty_generate(result)


if __FILE__ == $0
  main
end