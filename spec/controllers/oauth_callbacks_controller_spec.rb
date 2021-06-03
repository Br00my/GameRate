require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  let(:service) { double('FindForOuathService') }

  describe '#steam' do
    let(:oauth_data) { { provider: 'steam', uid: 123 } }

    before { @request.env['devise.mapping'] = Devise.mappings[:user] }
    
    before do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
    end
    
    it 'finds user from oauth data' do
      expect(FindForOauthService).to receive(:new).with(oauth_data).and_return(service)
      expect(service).to receive(:call)
      get :steam
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(FindForOauthService).to receive(:new).with(oauth_data).and_return(service)
        allow(service).to receive(:call).and_return(user)
        get :steam
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(FindForOauthService).to receive(:new).with(oauth_data).and_return(service)
        allow(service).to receive(:call)
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