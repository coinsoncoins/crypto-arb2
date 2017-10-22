
require './app/app'

RSpec.describe do
  it do
    bittrex_client = BittrexClient.new
    fixture = open("./spec/fixtures/bittrex_api_call.json").read;
    stub_request(:any, bittrex_client.url).to_return(body: fixture)
    bittrex_exchange = bittrex_client.get_exchange()

    hitbtc_client = HitBtcClient.new
    fixture = open("./spec/fixtures/hitbtc_api_call.json").read;
    stub_request(:any, hitbtc_client.url).to_return(body: fixture)
    hitbtc_exchange = hitbtc_client.get_exchange()

    puts 'bittrex / hitbtc'
    arb_opps = ArbFinder.new(bittrex_exchange, hitbtc_exchange).compare
    arb_opps.each do |arp_opp|
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


