FactoryBot.define do
  factory :tag_set_permission do
    language { "MyString" }
    read_access { false }
    update_access { false }
    tag_set { nil }
    user_references { "MyString" }
  end
end
