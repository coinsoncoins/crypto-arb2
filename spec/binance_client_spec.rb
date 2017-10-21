
require './app/binance_client'

RSpec.describe BinanceClient do
  context "#parse_snapshot" do
    it "parses" do
      binance_client = BinanceClient.new
      snapshot = open("./spec/data/binance_api_call.json").read;
      markets = binance_client.parse_snapshot(snapshot)
      expect(markets["ETHBTC"]).to eq(0.04895500)
    end
  end
end