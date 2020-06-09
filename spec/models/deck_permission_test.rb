require 'rails_helper'

RSpec.describe Deck, type: :model do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck) }
  let!(:deck_permission) { DeckPermission.new(user: user, deck: deck) }

  before { sign_in user }
  it "is valid with valid attributes" do
    expect(deck_permission).to be_valid
  end

  # it "is valid with an access level assigned" do
  # end
end
