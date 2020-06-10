FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 6) }
  end
end

FactoryBot.define do
  factory :deck do
    user { User.first || create(:user) }
  end
end

FactoryBot.define do
  factory :deck_permission do
    user { User.first || create(:user) }
    deck { Deck.first || create(:deck) }
  end
end
