FactoryBot.define do
  factory :product do
    name { "Standard Product" }
    description { "This is a standard product description." }
    price { 29.95 }
    category
    active { true }
  end
end
