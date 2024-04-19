FactoryBot.define do
  factory :order do
    customer_email { 'customer@example.com' }
    fulfilled { false }
    total { 100.0 } 
    address { '123 Main St' }
  end
end
