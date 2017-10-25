
class CoinNameRemapper

  def initialize(exchange_name)
    @coin_map = JSON.parse(open("./app/data/#{exchange_name}_coin_map.json").read)
    @coin_map_inverted = @coin_map.invert
  end

  def map(name)
    first_name, last_name = name.split('-')
    first_name = @coin_map[first_name] if @coin_map[first_name]
    [first_name, last_name].join('-')
  end

  def unmap(name)
    first_name, last_name = name.split('-')
    first_name = @coin_map_inverted[first_name] if @coin_map_inverted[first_name]
    [first_name, last_name].join('-')
  end

end