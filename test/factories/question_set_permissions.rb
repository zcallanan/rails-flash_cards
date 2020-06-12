FactoryBot.define do
  factory :question_set_permission do
    read_access { false }
    update_access { false }
    clone_access { false }
    user { nil }
    question_set { nil }
  end
end
