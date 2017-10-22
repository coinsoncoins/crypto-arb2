class Crypto
  attr_accessor :name, :bid, :ask, :exchange
  attr_accessor :volume_24h # volume is denominated in bitcoin
  def initialize(name:, bid: nil, ask: nil, volume_24h: nil, exchange: nil)
    @name = name
    @bid = bid.to_f
    @ask = ask.to_f
    @volume_24h = volume_24h.to_f
    @exchange = exchange
  end

  def valid?()
    @bid > 0.00000001 && @ask > 0.00000001
  end
end
