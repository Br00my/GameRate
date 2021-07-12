require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :username }
  it { should have_many :purchases }
  it { should have_many(:games) }
  it { should have_many :comments }
  it { should have_many :reviews }

  let(:author) { create(:user) }
  let(:game) { create(:game) }

  before { FactoryBot.create(:purchase, owner: author, game: game) }

  describe '#reviewed?' do
    it 'returns true if user has reviewed the game' do
      FactoryBot.create(:review, author: author, game: game)
      expect(author.reviewed?(game)).to be_truthy
    end

    it 'returns false if user has not reviewed the game' do
      expect(author.reviewed?(game)).to be_falsey
    end
  end

  describe '#owns?' do
    it 'returns true if user owns game' do
      expect(author.owns?(game)).to be_truthy
    end

    it 'returns false if user does not own game' do
      other_author = FactoryBot.create(:user, id: 100)
      other_game = FactoryBot.create(:game)
      FactoryBot.create(:purchase, owner: other_author, game: other_game)

      expect(author.owns?(other_game)).to be_falsey
    end
  end
end
