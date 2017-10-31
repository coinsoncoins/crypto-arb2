  
require './app/order_book_arber'


RSpec.describe OrderBookArber do

  context "#arb_order_books" do
    it "simple case" do
      market1 = Market.new(name: 'LTC-BTC')
      market2 = Market.new(name: 'NAV-BTC')
      book1, book2 = OrderBook.new(market1), OrderBook.new(market2)
      book1.add_entry(quantity: 100, price: 1, side: 'ask')
      book1.add_entry(quantity: 100, price: 2, side: 'ask')
      book1.add_entry(quantity: 100, price: 3, side: 'ask')
      book1.add_entry(quantity: 100, price: 4, side: 'ask')
      book1.add_entry(quantity: 100, price: 5, side: 'ask')
      book1.finish_adding_entries
      book2.add_entry(quantity: 100, price: 5, side: 'bid')
      book2.add_entry(quantity: 100, price: 4, side: 'bid')
      book2.add_entry(quantity: 100, price: 3, side: 'bid')
      book2.add_entry(quantity: 100, price: 2, side: 'bid')
      book2.add_entry(quantity: 100, price: 1, side: 'bid')
      book2.finish_adding_entries
      result = OrderBookArber.new(book1, book2).arb
      expect(result[:total_profit]).to eq(3_600_000)
      expect(result[:amount_to_arb]).to eq(200)
    end

    it "more complex case" do
      market1 = Market.new(name: 'LTC-BTC')
      market2 = Market.new(name: 'NAV-BTC')
      book1, book2 = OrderBook.new(market1), OrderBook.new(market2)
      book1.add_entry(quantity: 100, price: 1, side: 'ask')
      book1.add_entry(quantity: 30.5, price: 1.5, side: 'ask')
      book1.add_entry(quantity: 73, price: 2, side: 'ask')
      book1.add_entry(quantity: 90, price: 2.5, side: 'ask')
      book1.add_entry(quantity: 10, price: 3, side: 'ask')
      book1.finish_adding_entries
      book2.add_entry(quantity: 10, price: 3, side: 'bid')
      book2.add_entry(quantity: 40.8, price: 2.7, side: 'bid')
      book2.add_entry(quantity: 130, price: 2.2, side: 'bid')
      book2.add_entry(quantity: 70, price: 2, side: 'bid')
      book2.add_entry(quantity: 33, price: 1.5, side: 'bid')
      book2.finish_adding_entries
      result = OrderBookArber.new(book1, book2).arb
      expect(result[:total_profit]).to be_within(0.000001).of(1_078_860)
      expect(result[:amount_to_arb]).to eq(180.8)
    end
  end

end