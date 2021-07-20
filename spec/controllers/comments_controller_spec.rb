require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:purchase) { create(:purchase, owner: user) }
  let(:review) { create(:review, author: user, game: purchase.game) }

  describe 'POST #create' do
    context 'authenticated user' do
      before { login(user) }
      context 'creates comment with valid attributes' do
        it 'for user' do
          expect { post :create, params: { comment: { text: 'Fun to play' }, review_id: review, format: :js } }.to change(user.comments, :count).by(1)
        end

        it 'for review' do
          expect { post :create, params: { comment: { text: 'Fun to play' }, review_id: review, format: :js } }.to change(review.comments, :count).by(1)
        end

        it 'renders create' do
          post :create, params: { comment: { text: 'Fun to play' }, review_id: review, format: :js }

          expect(response).to render_template :create
        end

        it 'does not create comment if user does not own game' do
          other_user = FactoryBot.create(:user, id: 100)
          other_game = FactoryBot.create(:game)
          FactoryBot.create(:purchase, game: other_game, owner: other_user)
          other_review = FactoryBot.create(:review, author: other_user, game: other_game)

          expect { post :create, params: { comment: { text: 'Fun to play' }, review_id: other_review, format: :js } }.to_not change(Comment, :count)
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

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, review: review, author: user) }
    context 'authenticated user' do
      before { login(user) }
      it 'deletes comment' do
        expect { delete :destroy, params: { id: comment, format: :js } }.to change(Comment, :count).by(-1)
      end

      it 'renders destroy' do
        delete :destroy, params: { id: comment, format: :js }

        expect(response).to render_template :destroy
      end

      it "does not delete other user's comment" do
        other_user = FactoryBot.create(:user, id: 100)
        other_comment = FactoryBot.create(:comment, author: other_user, review: review)

        expect { delete :destroy, params: { id: other_comment, format: :js } }.to_not change(Comment, :count)
      end
    end

    context 'unauthenticated user' do
      it 'does not delete comment' do
        expect { delete :destroy, params: { id: comment, format: :js } }.to_not change(Comment, :count)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:comment) { create(:comment, review: review, author: user) }
    context 'authenticated user' do
      before { login(user) }
      it 'updates comment with calid attributes' do
        patch :update, params: { comment: { text: 'You are wrong' }, id: comment, format: :js }
        comment.reload

        expect(comment.text).to eq 'You are wrong'
      end

      it 'does not update comment with invalid attributes' do
        patch :update, params: { comment: { text: '' }, id: comment, format: :js }
        comment.reload

        expect(comment.text).to_not eq ''
      end

      it 'renders update' do
        patch :update, params: { comment: { text: 'You are wrong' }, id: comment, format: :js }

        expect(response).to render_template :update
      end

      it "does not update other user's comment" do
        other_user = FactoryBot.create(:user, id: 100)
        other_comment = FactoryBot.create(:comment, author: other_user, review: review)

        patch :update, params: { comment: { text: 'You are wrong' }, id: other_comment, format: :js }
      end
    end

    context 'unauthenticated user' do
      it 'does not update comment' do
        expect { patch :update, params: { comment: { text: 'you are wrong' }, id: comment, format: :js } }.to_not change(Comment, :count)
      end
    end
  end
end