class CryptoPair

  attr_accessor :name, :bid, :ask, :exchange, :base_name, :pair_name
  attr_accessor :volume_24h # volume is denominated in base currency
  def initialize(name:, bid: nil, ask: nil, volume_24h: nil, exchange: nil)
    # @pair_name = name
    # @base_name = name[-3..-1]
    # if !%w[BTC ETH USD USTD LTC].include?(@base_name)
    #   puts("unexpected base pair: #{name}")
    # end
    #@name = name[0...-3] 
    @name = name
    @bid = bid.to_f
    @ask = ask.to_f
    @volume_24h = volume_24h.to_f
    @exchange = exchange
  end

  def valid?()
    @bid > 0.00000001 && @ask > 0.00000001
  end

  # def eql?(other)
  #   @name == other.name && 
  #   @bid == other.bid &&
  #   @ask == other.ask &&
  #   @volume_24h = other.volume_24h
  #   @exchange = other.exchange
  # end

  def self.parse_base(name)
    base = /BTC$|ETC$|LTC$/.match(name).to_s
    crypto = name.sub(base, '')
    [crypto, base]
  end

end
