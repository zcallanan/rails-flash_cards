require 'rails_helper'

RSpec.describe Deck, type: :model do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck) }
  let!(:deck_permission) { create(:deck_permission) }

  before { sign_in user }
  context 'validations' do
    it "is valid with valid attributes" do
      expect(deck_permission).to be_valid
    end
  end
end
