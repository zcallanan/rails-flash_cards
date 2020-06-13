class User < ApplicationRecord
  # enum role: %i[registered admin]
  # after_initialize :set_default_role, if: :new_record?

  # def set_default_role
  #   self.role ||= :registered
  # end
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :deck_permissions
  has_many :decks, through: :deck_permissions
  has_many :memberships
  has_many :user_groups, through: :memberships
  has_many :collection_permissions
  has_many :collections, through: :collection_permissions
  has_many :question_set_permissions
  has_many :question_sets, through: :question_set_permissions
  has_many :answers

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
