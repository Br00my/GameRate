require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:purchase) { create(:purchase) }

  describe '#set_multiplier' do
    it 'sets rate multiplier' do
      review = Review.create!(author: purchase.owner, game: purchase.game, text: 'Fun to play', rate: 1)
      expect(review.multiplier).to eq 1
    end
  end

  describe '#set_game_rate' do
    let(:review) { create(:review, author: purchase.owner, game: purchase.game) }

    describe 'game rate is nil' do
      it 'sets game rate' do
        expect(review.game.rate).to eq 1
      end
    end

    describe 'game rate exists' do
      it 'changes game rate' do
        new_review = FactoryBot.create(:review, author: review.author, game: review.game, rate: 4)
        expect(review.game.rate).to eq 2.5
      end
    end
  end
end
