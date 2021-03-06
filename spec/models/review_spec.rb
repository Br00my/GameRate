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
      excess_review = Review.new(author: user, game: game, text: 'Interesting plot', rate: 1)
      expect(excess_review.save).to be_falsey
    end
  end

  describe '#set_game_rate' do
    let(:user) { create(:user) }
    let(:game) { create(:game) }
    
    before do
      FactoryBot.create(:purchase, game: game, owner: user)
      FactoryBot.create(:review, game: game, author: user)
    end

    describe 'one review' do
      it 'returns game rate' do
        expect(game.rate).to eq 1.0
      end
    end

    describe 'multiple reviews' do
      let(:new_user){ create(:user, id: 1) }

      it 'returns game rate' do
        FactoryBot.create(:purchase, game: game, owner: new_user)
        FactoryBot.create(:review, game: game, author: new_user, rate: 4)
        expect(game.rate).to eq 2.5
      end
    end
  end
end
