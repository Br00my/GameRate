require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  let(:purchase) { create(:purchase) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(purchase.owner) }
      context 'creates review with valid attributes' do
        it 'for user' do
          expect { post :create, params: { review: { rate: 5, text: 'Fun to play' }, game_id: purchase.game, format: :js } }.to change(purchase.owner.reviews, :count).by(1)
        end

        it 'for game' do
          expect { post :create, params: { review: { rate: 5, text: 'Fun to play' }, game_id: purchase.game, format: :js } }.to change(purchase.game.reviews, :count).by(1)
        end

        it 'renders create' do
          post :create, params: { review: { rate: 5, text: 'Fun to play' }, game_id: purchase.game, format: :js }

          expect(response).to render_template :create
        end
      end
    end

    context 'unauthenticated user' do
      it 'does not create review' do
        expect { post :create, params: { review: { rate: 5, text: 'Fun to play' }, game_id: purchase.game, format: :js } }.to_not change(Review, :count)
      end
    end
  end
end