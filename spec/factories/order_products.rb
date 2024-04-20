FactoryBot.define do
  factory :order_product do
    order
    quantity { rand(1..5) }
  end
end
