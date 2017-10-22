
require "./app/binance_client"
require "./app/bittrex_client"
require './app/hitbtc_client'
require './app/cryptopia_client'
require './app/arb_finder'
require './app/arb_opp'
require './app/message_formatter'


def main()

  puts "getting exchange data..."
  bittrex_exchange = BittrexClient.new.get_exchange()
  #binance_markets = BinanceClient.new.get_snapshot()
  hitbtc_exchange = HitBtcClient.new.get_exchange()
  cryptopia_exchange = CryptopiaClient.new.get_exchange()
  binance_exchange = BinanceClient.new.get_exchange()

  arb_opps = []
  puts "finding arbs from bittrex..."
  arb_opps += ArbFinder.new(bittrex_exchange, hitbtc_exchange).compare
  arb_opps += ArbFinder.new(bittrex_exchange, cryptopia_exchange).compare
  arb_opps += ArbFinder.new(bittrex_exchange, binance_exchange).compare

  puts "finding arbs from binance..."
  arb_opps += ArbFinder.new(binance_exchange, bittrex_exchange).compare
  arb_opps += ArbFinder.new(binance_exchange, cryptopia_exchange).compare
  arb_opps += ArbFinder.new(binance_exchange, hitbtc_exchange).compare

  puts "finding arbs from hitbtc"
  arb_opps += ArbFinder.new(hitbtc_exchange, bittrex_exchange).compare
  arb_opps += ArbFinder.new(hitbtc_exchange, cryptopia_exchange).compare
  arb_opps += ArbFinder.new(hitbtc_exchange, binance_exchange).compare

  puts "finding arbs from cryptopia"
  arb_opps += ArbFinder.new(cryptopia_exchange, bittrex_exchange).compare
  arb_opps += ArbFinder.new(cryptopia_exchange, hitbtc_exchange).compare
  arb_opps += ArbFinder.new(cryptopia_exchange, binance_exchange).compare

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