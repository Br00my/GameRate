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
        
        it 'does not create more than one review for one author' do
          FactoryBot.create(:review, author: purchase.owner, game: purchase.game)
          expect { post :create, params: { review: { rate: 5, text: 'Fun to play' }, game_id: purchase.game, format: :js } }.to_not change(Review, :count)
        end

        it 'does not create review if user does not own game' do
          other_user = FactoryBot.create(:user, id: 100)
          other_game = FactoryBot.create(:game)
          FactoryBot.create(:purchase, game: other_game, owner: other_user)

          expect { post :create, params: { review: { rate: 5, text: 'Fun to play' }, game_id: other_game, format: :js } }.to_not change(Review, :count)
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
      
      it 'updates review with valid attributes' do
        patch :update, params: { review: { rate: 5, text: 'Good plot' }, id: review, format: :js }
        review.reload

        expect(review.rate).to eq 5
        expect(review.text).to eq 'Good plot'
      end

      it 'updates review with invalid attributes' do
        patch :update, params: { review: { rate: nil, text: 'Good plot' }, id: review, format: :js }
        review.reload

        expect(review.rate).to_not eq 5
        expect(review.text).to_not eq 'Good plot'
      end

      it 'renders update' do
        patch :update, params: { review: { rate: 5, text: 'Good plot' }, id: review, format: :js }

        expect(response).to render_template :update
      end

      it "does not update other user's review" do
        other_user = FactoryBot.create(:user, id: 100)
        FactoryBot.create(:purchase, owner: other_user, game: purchase.game)
        other_review = FactoryBot.create(:review, author: other_user, game: purchase.game)

        patch :update, params: { review: { rate: 5, text: 'Good plot' }, id: other_review, format: :js }
        review.reload

        expect(other_review.text).to_not eq 'Good plot'
      end
    end

    context 'unauthenticated user' do
      it 'does not update review' do
        patch :update, params: { review: { rate: 5, text: 'Good plot' }, id: review, format: :js }
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
        expect { delete :destroy, params: { id: review, format: :js } }.to change(Review, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { id: review, format: :js }

        expect(response).to render_template :destroy
      end

      it "does not delete other user's review" do
        other_user = FactoryBot.create(:user, id: 100)
        FactoryBot.create(:purchase, owner: other_user, game: purchase.game)
        other_review = FactoryBot.create(:review, author: other_user, game: purchase.game)

        expect { delete :destroy, params: { id: other_review, format: :js } }.to_not change(Review, :count)
      end
    end

    context 'unauthenticated user' do
      it 'does not delete review' do
        expect { delete :destroy, params: { id: review, format: :js } }.to_not change(Review, :count)
      end
    end
  end
end