require 'rails_helper'

RSpec.describe Address, type: :model do 
  describe "validations" do 
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end 
  describe 'relationships' do 
    it { should belong_to :user }
    it { should have_many :orders }
  end 
  describe 'instance method' do 
    it '.check_orders' do 
      @user = create(:user)
      @address = create(:address, user: @user)

      create(:shipped_order, address: @address, user: @user)

      expect(@address.check_orders).to eq(true)
      
    end 
  end 
end 