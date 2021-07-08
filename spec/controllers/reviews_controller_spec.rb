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

      it 'does not create review with invalid attributes' do
        expect { post :create, params: { review: { rate: nil, text: 'Fun to play' }, game_id: purchase.game, format: :js } }.to_not change(Review, :count)
      end
    end

    context 'unauthenticated user' do
      it 'does not create review' do
        expect { post :create, params: { review: { rate: 5, text: 'Fun to play' }, game_id: purchase.game, format: :js } }.to_not change(Review, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:review){ create(:review, author: purchase.owner, game: purchase.game) }

    context 'authenticated user' do
      before { login(purchase.owner) }
      
      context 'valid attributes' do
        it 'updates review update review' do
          patch :update, params: { review: { rate: 5, text: 'Good plot' }, game_id: purchase.game, id: review, format: :js }
          review.reload

          expect(review.rate).to eq 5
          expect(review.text).to eq 'Good plot'
        end

        it 'renders update' do
          patch :update, params: { review: { rate: 5, text: 'Good plot' }, game_id: purchase.game, id: review, format: :js }

          expect(response).to render_template :update
        end
      end

      it 'updates review with invalid attributes' do
        patch :update, params: { review: { rate: nil, text: 'Good plot' }, game_id: purchase.game, id: review, format: :js }
        review.reload

        expect(review.rate).to_not eq 5
        expect(review.text).to_not eq 'Good plot'
      end
    end

    context 'unauthenticated user' do
      it 'does not update review' do
        patch :update, params: { review: { rate: 5, text: 'Good plot' }, game_id: purchase.game, id: review, format: :js }
        review.reload

        expect(review.rate).to_not eq 5
        expect(review.text).to_not eq 'Good plot'
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:review){ create(:review, author: purchase.owner, game: purchase.game) }

    context 'authenticated user' do
      before { login(purchase.owner) }
      
      it 'deletes review' do
        expect { delete :destroy, params: { game_id: purchase.game, id: review, format: :js } }.to change(Review, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { game_id: purchase.game, id: review, format: :js }

        expect(response).to render_template :destroy
      end
    end

    context 'unauthenticated user' do
      it 'does not delete review' do
        expect { delete :destroy, params: { game_id: purchase.game, id: review, format: :js } }.to_not change(Review, :count)
      end
    end
  end
end