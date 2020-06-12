FactoryBot.define do
  factory :tag_permission do
    read_access { false }
    write_access { false }
    user { nil }
    tag_set { nil }
  end
end
