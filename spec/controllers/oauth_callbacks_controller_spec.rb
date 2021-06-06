require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe '#steam' do
    let(:oauth_data) { { provider: 'steam', uid: 123 } }

    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      it 'login user if it exists' do
        byebug
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        get :steam
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not login user if it does not exist' do
        expect(subject.current_user).to_not be
      end
    end
  end
end