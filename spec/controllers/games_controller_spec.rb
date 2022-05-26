require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'POST #update_list' do
    let(:service) { double('AddOwnedGamesService') }
    let(:user){ create(:user) }

    describe 'Authenticated user' do
      before { login(user) }

      it 'adds new games to user' do
        expect(AddOwnedGamesService).to receive(:new).with(user).and_return(service)
        expect(service).to receive(:call)
        post :update_list
      end

      it 'redirects to root path' do
        post :update_list
        expect(response).to redirect_to root_path
      end
    end

    it 'does not add new games if user is not authenticated' do
      expect(AddOwnedGamesService).to_not receive(:new)
      post :update_list
    end
  end
end