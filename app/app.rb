
require "./app/binance_client"
require "./app/bittrex_client"
require './app/hitbtc_client'
require './app/cryptopia_client'
require './app/liqui_client'
require './app/poloniex_client'
require './app/kraken_client'
require './app/livecoin_client'
require './app/kucoin_client'
require './app/coinexchange_client'
require './app/etherdelta_client'
require './app/arb_finder'
require './app/arb_opp'
require './app/message_formatter'


def main()

  puts "getting exchange data..."
  
  #puts 'etherdelta'; etherdelta_client = EtherDeltaClient.new.get_exchange()
  puts 'bittrex'; bittrex_exchange = BittrexClient.new.get_exchange()
  puts 'hitbtc'; hitbtc_exchange = HitBtcClient.new.get_exchange()
  puts 'cryptopia'; cryptopia_exchange = CryptopiaClient.new.get_exchange()
  puts 'binance'; binance_exchange = BinanceClient.new.get_exchange()
  puts 'liqui'; liqui_exchange = LiquiClient.new.get_exchange()
  puts 'poloniex'; poloniex_exchange = PoloniexClient.new.get_exchange()
  puts 'kucoin'; kucoin_exchange = KucoinClient.new.get_exchange()
  # #puts 'coinexchange'; coinexchange_client = CoinExchangeClient.new.get_exchange()
  # #kraken_exchange = KrakenClient.new.get_exchange()
  # #livecoin_exchange = LivecoinClient.new.get_exchange()

  puts 'finding arb opps'
  arb_opps = []
  exchanges = [bittrex_exchange, hitbtc_exchange, cryptopia_exchange, 
    binance_exchange, liqui_exchange, poloniex_exchange, kucoin_exchange]
  # [kucoin_exchange, 
  #   bittrex_exchange, hitbtc_exchange, liqui_exchange, cryptopia_exchange, 
  #   poloniex_exchange, binance_exchange]
    

  exchanges.each do |exchange1|
    exchanges.each do |exchange2|
      arb_opps += ArbFinder.new(exchange1, exchange2).compare
    end
  end

  arb_opps = arb_opps.sort_by { |opp| opp.potential_profit }.reverse
  arb_opps.each do |arp_opp|
    if arb_opp.potential_profit > 30.0
      puts MessageFormatter.arb_opp(arp_opp)
    end
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