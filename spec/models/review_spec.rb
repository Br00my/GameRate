require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:user) { create(:user) }
  let(:game) { create(:game) }
  let!(:purchase) { create(:purchase, owner: user, game: game) }

  describe '#set_multiplier' do
    it 'sets rate multiplier' do
      review = Review.create!(author: user, game: game, text: 'Fun to play', rate: 1)
      expect(review.multiplier).to eq 1
    end
  end

  describe '#one_reviewer' do
    it 'adds error if user has more than one review to one game' do
      FactoryBot.create(:review, author: user, game: game)
      excess_review = FactoryBot.create(:review, author: user, game: game)
      expect(excess_review.persisted?).to be_falsey
    end
  end
end
