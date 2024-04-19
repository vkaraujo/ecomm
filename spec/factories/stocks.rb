FactoryBot.define do
  factory :stock do
    product
    size { "M" }
    amount { 100 }
  end
end
