FactoryBot.define do
  factory :review do
    title { "MyString" }
    body { "MyString" }
    rating { 1.5 }
    user { nil }
    deck { nil }
  end
end
