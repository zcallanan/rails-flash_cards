require 'rails_helper'

RSpec.describe Deck, type: :model do
  let!(:user) { create(:user) }
  before { sign_in user }
  it "is valid with valid attributes" do
    expect(Deck.new).to be_valid
  end
end
