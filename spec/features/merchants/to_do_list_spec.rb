require 'rails_helper'

include ActionView::Helpers::NumberHelper

RSpec.describe 'Merchant to do dashboard' do
  describe 'see items with placeholder image' do 
    it 'can click on image to take me to item edit page' do 
      @merchant = create(:merchant)
      @item_1, @item_2 = create_list(:item, 2, user: @merchant, image: "https://memegenerator.net/img/instances/80976711.jpg")
      @item_3 = create(:inactive_item, user: @merchant)
      @order_1, @order_2 = create_list(:order, 2)
      @order_3 = create(:shipped_order)
      @order_4 = create(:cancelled_order)
      create(:order_item, order: @order_1, item: @item_1, quantity: 1, price: 2)
      create(:order_item, order: @order_1, item: @item_2, quantity: 2, price: 2)
      create(:order_item, order: @order_2, item: @item_2, quantity: 4, price: 2)
      create(:order_item, order: @order_3, item: @item_1, quantity: 4, price: 2)
      create(:order_item, order: @order_4, item: @item_2, quantity: 5, price: 2)
  
      login_as(@merchant)
      visit dashboard_items_path
      save_and_open_page

    end 
  end 
end 