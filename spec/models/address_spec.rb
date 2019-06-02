require 'rails-helper'

RSpec.describe Address do 
  describe "validations" do 
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end 
  describe 'relationships' do 
    it { should belong_to :users }
  end 
end 