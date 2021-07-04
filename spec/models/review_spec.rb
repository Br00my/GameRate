require 'rails_helper'

RSpec.describe Review, type: :model do
  describe '#set_multiplier' do
    let(:purchase){create(:purchase)}

    it 'sets rate multiplier' do
      review = Review.create!(author: purchase.owner, game: purchase.game, text: 'Fun to play', rate: 1)
      expect(review.multiplier).to eq 1
    end
  end
end
