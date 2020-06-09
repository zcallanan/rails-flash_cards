require 'rails_helper'

RSpec.describe Deck, type: :model do
  let!(:user) { create(:user) }
  let!(:deck) { create(:deck) }

  before { sign_in user }
  it "is valid with valid attributes" do
    expect(DeckPermission.new(user: user, deck: deck)).to be_valid
  end
end
