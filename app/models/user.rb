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

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
