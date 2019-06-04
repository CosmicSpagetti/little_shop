class Address < ApplicationRecord
  belongs_to :user
  has_many :orders 
  validates_presence_of :address, :city, :state, :zip, :nickname

  def check_orders
    orders.any?{|order| order[:status] == 'packaged' || order[:status] == 'shipped'}
  end 
end 