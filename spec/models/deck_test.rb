require 'rails_helper'

RSpec.describe Deck, type: :model do
  let!(:user) { create(:user) }
  context 'validations' do
    it "is valid with valid attributes" do
      expect(Deck.new(user: user)).to be_valid
    end
  end
  context 'associations' do
    it { should belong_to(:user) }
  end
end
