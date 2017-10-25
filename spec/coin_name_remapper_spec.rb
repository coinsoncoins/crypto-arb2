
require './app/coin_name_remapper'

RSpec.describe CoinNameRemapper do
  context "#map/#unmap" do
    it do
      remapper = CoinNameRemapper.new('cryptopia')
      expect(remapper.map('FCN-BTC')).to eq('facilecoin_FCN-BTC')
      expect(remapper.unmap('facilecoin_FCN-BTC')).to eq('FCN-BTC')
    end
  end
end