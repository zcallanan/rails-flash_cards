FactoryBot.define do
  factory :user do
    email { "zach@example.com" }
    password { "secret" }
    # name  { "John Doe" }
    # admin { true }
  end
end

FactoryBot.define do
  factory :deck do
  end
end
