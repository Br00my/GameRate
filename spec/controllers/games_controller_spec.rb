require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'GET #index' do
    let(:games) { create_list(:game, 3) }

    before { get :index }

    it 'populates an array of all games' do
      expect(assigns(:games)).to match_array(games)
    end
  end

  describe 'POST #update_list' do
    let(:service) { double('AddOwnedGamesService') }
    let(:user){ create(:user) }

    before { login(user) }

    it 'adds new games' do
      expect(AddOwnedGamesService).to receive(:new).with(user).and_return(service)
      expect(service).to receive(:call)
      post :update_list
    end

    it 'redirects to root path' do
      post :update_list
      expect(response).to redirect_to root_path
    end
  end
end