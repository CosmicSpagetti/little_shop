FactoryBot.define do
  factory :address do
    sequence(:address) { |n| "Address #{n}" }
       sequence(:city) { |n| "City #{n}" }
       sequence(:state) { |n| "state #{n}" }
       sequence(:zip) { |n| "Zip #{n}" }
       user
  end 
end 