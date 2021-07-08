require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :username }
  it { should have_many :purchases }
  it { should have_many(:games) }

  describe '#reviewed?' do
    let(:author) { create(:user) }
    let(:game) { create(:game) }

    before { FactoryBot.create(:purchase, owner: author, game: game) }

    it 'returns true if user has reviewed the game' do
      FactoryBot.create(:review, author: author, game: game)
      expect(author.reviewed?(game)).to be_truthy
    end

    it 'returns false if user has not reviewed the game' do
      expect(author.reviewed?(game)).to be_falsey
    end
  end
end
