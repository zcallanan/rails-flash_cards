class User < ApplicationRecord
  acts_as_token_authenticatable

  has_many :deck_permissions
  has_many :decks, through: :deck_permissions
  has_many :memberships
  has_many :user_groups, through: :memberships
  has_many :collection_permissions
  has_many :collections, through: :collection_permissions
  has_many :question_set_permissions
  has_many :question_sets, through: :question_set_permissions
  has_many :tag_set_permissions
  has_many :tag_sets, through: :tag_set_permissions
  has_many :answers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
