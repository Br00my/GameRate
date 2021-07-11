require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:purchase) { create(:purchase) }
  let(:review) { create(:review, author: purchase.owner, game: purchase.game) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(purchase.owner) }
      context 'creates comment with valid attributes' do
        it 'for user' do
          expect { post :create, params: { comment: { text: 'Fun to play' }, review_id: review, format: :js } }.to change(purchase.owner.comments, :count).by(1)
        end

        it 'for review' do
          expect { post :create, params: { comment: { text: 'Fun to play' }, review_id: review, format: :js } }.to change(review.comments, :count).by(1)
        end

        it 'renders create' do
          post :create, params: { comment: { text: 'Fun to play' }, review_id: review, format: :js }

          expect(response).to render_template :create
        end
      end

      it 'does not create comment with invalid attributes' do
        expect { post :create, params: { comment: { text: nil }, review_id: review, format: :js } }.to_not change(Comment, :count)
      end
    end

    context 'unauthenticated user' do
      it 'does not create comment' do
        expect { post :create, params: { comment: { text: 'Fun to play' }, review_id: review, format: :js } }.to_not change(Comment, :count)
      end
    end
  end
end