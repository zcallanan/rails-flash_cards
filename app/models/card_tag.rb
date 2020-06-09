class CardTag < ApplicationRecord
  belongs_to :card
  belongs_to :tag
end
