FactoryBot.define do
  factory :user_log do
    event { "MyString" }
    user { nil }
    deck { nil }
    collection { nil }
  end
end
