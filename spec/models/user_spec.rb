require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :username }
  it { should have_many :purchases }
  it { should have_many(:games) }
  it { should have_many :comments }
  it { should have_many :reviews }

  let(:user) { create(:user) }
  let(:game) { create(:game) }

  before { FactoryBot.create(:purchase, owner: user, game: game) }

  describe '#reviewed?' do
    it 'returns true if user has reviewed the game' do
      FactoryBot.create(:review, author: user, game: game)
      expect(user.reviewed?(game)).to be_truthy
    end

    it 'returns false if user has not reviewed the game' do
      expect(user.reviewed?(game)).to be_falsey
    end
  end

  describe '#owns?' do
    it 'returns true if user owns game' do
      expect(user.owns?(game)).to be_truthy
    end

    it 'returns false if user does not own game' do
      other_user = FactoryBot.create(:user, id: 100)
      other_game = FactoryBot.create(:game)
      FactoryBot.create(:purchase, owner: other_user, game: other_game)

      expect(user.owns?(other_game)).to be_falsey
    end
  end

  describe '#review_author?' do
    let!(:review) { create(:review, author: user, game: game) }
    it 'returns true if review belongs to user' do
      expect(user.review_author?(review)).to be_truthy
    end

    it 'returns false if reviewdoes not belong to user' do
      other_user = FactoryBot.create(:user, id: 100)
      expect(other_user.review_author?(review)).to be_falsey
    end
  end
end
