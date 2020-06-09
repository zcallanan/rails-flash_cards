class Deck < ApplicationRecord
  has_many :deck_permissions
  has_many :users, through: :deck_permissions
end
