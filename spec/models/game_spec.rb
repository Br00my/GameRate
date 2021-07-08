require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :picture }
  it { should validate_presence_of :genres }

  it { should have_many :purchases }
  it { should have_many :owners }

  describe '#rate' do
    let(:user){ create(:user) }
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

      before do
        FactoryBot.create(:purchase, game: game, owner: new_user)
        FactoryBot.create(:review, game: game, author: new_user, rate: 4)
      end

      it 'returns game rate' do
        expect(game.rate).to eq 2.5
      end
    end
  end
end
