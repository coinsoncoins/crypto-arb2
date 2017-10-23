
require './app/order_book'


RSpec.describe OrderBook do
  context "#get_sum_of_side" do
    it "raises exception if not 'finished_adding_entries' called" do
      order_book = OrderBook.new
      order_book.add_entry(quantity: 10000, price: 0.0002, side: 'bid')
      expect{order_book.get_cost_of_side('bid')}.to raise_error(RuntimeError)
    end
    it '#get_cost_of_side on bid side' do
      order_book = OrderBook.new
      order_book.add_entry(quantity: 10000, price: 0.0002, side: 'bid')
      order_book.add_entry(quantity: 15000, price: 0.00018, side: 'bid')
      order_book.add_entry(quantity: 20000, price: 0.00015, side: 'bid')
      order_book.finish_adding_entries()
      cost = order_book.get_cost_of_side('bid')
      expect(cost).to eq(7.699999999999999)

      # with a cutoff
      cost = order_book.get_cost_of_side('bid', 0.00017)
      expect(cost).to eq(4.7)
    end

    it '#get_cost_of_side on ask side' do
      order_book = OrderBook.new
      order_book.add_entry(quantity: 10000, price: 0.0002, side: 'ask')
      order_book.add_entry(quantity: 15000, price: 0.00022, side: 'ask')
      order_book.add_entry(quantity: 20000, price: 0.00025, side: 'ask')
      order_book.finish_adding_entries()
      cost = order_book.get_cost_of_side('ask')
      expect(cost).to eq(10.3)

      # with a cutoff
      cost = order_book.get_cost_of_side('ask', 0.00023)
      expect(cost).to eq(5.300000000000001)
    end

  end

end