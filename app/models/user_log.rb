class UserLog < ApplicationRecord
  belongs_to :user
  belongs_to :deck, optional: true
  belongs_to :collection, optional: true
  belongs_to :card, optional: true
  belongs_to :collection_card, optional: true
  belongs_to :tag_relation, optional: true
  belongs_to :tag, optional: true
  belongs_to :question_set, optional: true
  belongs_to :user_group, optional: true
  belongs_to :deck_permission, optional: true
  belongs_to :membership, optional: true
  belongs_to :deck_string, optional: true
  belongs_to :collection_string, optional: true
  belongs_to :question_set_string, optional: true
  belongs_to :card_string, optional: true
  belongs_to :review, optional: true
end
