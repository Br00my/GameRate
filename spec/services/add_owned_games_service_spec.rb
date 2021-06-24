require 'rails_helper'

RSpec.describe AddOwnedGamesService do
  let(:user) { create(:user) }

  it 'finds existing games' do
    existing_game = Game.create(id: 10, title: 'Counter-Strike', picture: 'picture', genres: 'Action')
    AddOwnedGamesService.new(user).call

    expect(user.games).to include existing_game
  end
  
  it 'creates games' do
    AddOwnedGamesService.new(user).call

    expect(user.games.pluck(:id)).to include 10
    expect(user.games.pluck(:title)).to include 'Counter-Strike'
  end

  it 'creates purchase' do
    AddOwnedGamesService.new(user).call

    SteamCov.owned_games(user.id).each do |game|
      playtime = game['playtime_forever'] / 60
      expect(user.purchases.pluck(:playtime)).to include playtime
    end
  end
end