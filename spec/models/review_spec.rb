require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:purchase) { create(:purchase) }

  describe '#set_multiplier' do
    it 'sets rate multiplier' do
      review = Review.create!(author: purchase.owner, game: purchase.game, text: 'Fun to play', rate: 1)
      expect(review.multiplier).to eq 1
    end
  end
end
