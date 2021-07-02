require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#steam' do
    let(:oauth_data) { { provider: 'steam', uid: 76561199163469955, info: { nickname: 'tester' } } }

    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before { get :steam }

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      it 'creates user' do
        expect{ get :steam }.to change(User, :count).by(1)
      end

      it 'login user if it exists' do
        get :steam
        expect(subject.current_user.id).to eq 76561199163469955
      end

      it 'redirects to root path' do
        get :steam
        expect(response).to redirect_to root_path
      end
    end
  end
end