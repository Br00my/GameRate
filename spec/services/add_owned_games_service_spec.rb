require 'rails_helper'

RSpec.describe AddOwnedGamesService do
  let(:user) { create(:user) }
  
  it 'creates games' do
    AddOwnedGamesService.new(user).call

    SteamCover.owned_games(user).each do |game|
      game_genres = SteamCover.game_details(game['appid'])["data"]["genres"].map{|x|x['description']}.join(', ')
      expect(user.games.pluck(:title)).to include game['name']
      expect(user.games.pluck(:genres)).to include game_genres
    end
  end

  it 'creates purchase' do
    AddOwnedGamesService.new(user).call

    SteamCover.owned_games(user).each do |game|
      playtime = game['playtime_forever'] / 60
      expect(user.purchases.pluck(:playtime)).to include playtime
    end
  end
end