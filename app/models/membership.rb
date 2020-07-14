class Membership < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :user_group
  has_many :user_logs

  validates :user_label, length: { minimum: 3 }
  validates :email_contact, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i, message: "That is not a valid email." }
end
