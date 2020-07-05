class User < ApplicationRecord
  acts_as_token_authenticatable

  has_many :deck_permissions
  has_many :decks, through: :deck_permissions
  has_many :memberships
  has_many :user_groups, through: :memberships
  has_many :answers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
