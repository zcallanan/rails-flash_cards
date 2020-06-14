class CollectionString < ApplicationRecord
  belongs_to :collection

  validates :language, :title, presence: true, uniqueness: true
end
