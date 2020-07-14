class UserGroup < ApplicationRecord
  belongs_to :user
  has_many :memberships
  has_many :users, through: :memberships
  has_many :user_group_decks
  has_many :decks, through: :user_group_decks
  has_many :user_logs
  accepts_nested_attributes_for :decks

  scope :user_groups_owned, lambda { |user|
    includes(:memberships).where(user: user).references(:memberships).distinct
  }

  scope :user_groups_not_owned, lambda { |user, update|
    includes(users: [:memberships, :decks]).where({ memberships: { user_id: user.id, read_access: true, update_access: update } }, decks: { archived: false }).where.not(user: user).references(users: [:memberships, :decks]).distinct
  }
end
