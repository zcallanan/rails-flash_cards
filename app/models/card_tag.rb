class CardTag < ApplicationRecord
  belongs_to :tag_set
  belongs_to :card
end
