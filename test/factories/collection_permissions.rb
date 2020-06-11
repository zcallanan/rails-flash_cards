FactoryBot.define do
  factory :collection_permission do
    read_access { "" }
    update_access { "" }
    clone_access { "" }
    user { "" }
    deck { nil }
  end
end
