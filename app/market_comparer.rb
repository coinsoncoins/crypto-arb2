
class MarketComparer
  def self.compare(market1, market2)
    results = []
    market1.each do |key, value|
      if market2.key?(key)

        if market1[key].to_f == 0.0
          diff = 1000000.0
        else
          diff = (market2[key].to_f - market1[key].to_f) / market1[key].to_f * 100.0
        end
        results.push({symbol: key, diff: diff})
      end
    end

    results.sort_by! { |r| r[:diff] }
    results.reverse
  end
end
