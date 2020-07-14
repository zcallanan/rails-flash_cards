class DeckPermission < ApplicationRecord
  belongs_to :deck
  belongs_to :user
  has_many :user_logs
end
