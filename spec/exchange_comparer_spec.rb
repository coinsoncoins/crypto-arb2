
# require './app/exchange_comparer'

# def create_exchanges()
#   exchange1 = {
#     name: 'bittrex',
#     markets: {
#       BTCUSD: {
#         bid: 5990,
#         ask: 6000,
#         volume: 1_000_000
#       },
#       MTLBTC: {
#         bid: 0.001,
#         ask: 0.0012,
#         volume: 6_000
#       }
#     }
#   }
#   exchange2 = {
#     name: 'hitbtc',
#     markets: {
#       BTCUSD: {
#         bid: 6060,
#         ask: 6070,
#         volume: 2_000_000
#       },
#       MTLBTC: {
#         bid: 0.0012,
#         ask: 0.001,
#         volume: 6_000
#       }
#     }
#   }
#   [exchange1, exchange2]
# end


# RSpec.describe ExchangeComparer do
#   context "#compare" do
#     it "" do
#       exchange1, exchange2 = create_exchanges()
#       results = ExchangeComparer.compare(exchange1, exchange2)
#       results1 = results[0]
#       expect(results1.market).to eq('BTCUSD')
#       expect(results1.exchange1).to eq('bittrex')
#       expect(results1.ask1).to eq(6000)
#       expect(results1.volume1).to eq(1_000_000)
#       expect(results1.exchange2).to eq('hitbtc')
#       expect(results1.bid2).to eq(6060)
#       expect(results1.volume2).to eq(2_000_000)
#       expect(results1.gain).to eq(0.01)

#       # result2 = results[1]
#       # expect(results1.market).to eq('MTLBTC')
#       # expect(results1.exchange1).to eq('bittrex')
#       # expect(results1.ask1).to eq(0.0012)
#       # expect(results1.volume1).to eq(6_000)

#     end
#     it '' do
#       bittrex_client = BittrexClient.new
#       snapshot = open("./spec/data/bittrex_api_call.json").read;
#       markets = bittrex_client.parse_snapshot(snapshot)

#       hitbtc_client = HitBtcClient.new
#       snapshot = open("./spec/data/hitbtc_api_call.json").read;
#       markets = hitbtc_client.parse_snapshot(snapshot)
#     end

#   end
# end










