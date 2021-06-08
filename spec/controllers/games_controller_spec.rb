require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'GET #index' do
    let(:games) { create_list(:game, 3) }

    before { get :index }

    it 'populates an array of all games' do
      expect(assigns(:games)).to match_array(games)
    end
  end
end