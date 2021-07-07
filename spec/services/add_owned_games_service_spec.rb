require 'rails_helper'

RSpec.describe AddOwnedGamesService do
  let!(:user) { create(:user) }

  it 'creates games' do
    AddOwnedGamesService.new(user).call
    
    steam_games = SteamCov.owned_games(user.id)
    user.games.each do |game|
      expect(steam_games.map{|game| game['appid']}).to include game.id
      expect(steam_games.map{|game| game['name']}).to include game.title
    end
  end

  it 'creates purchases' do
    AddOwnedGamesService.new(user).call

    SteamCov.owned_games(user.id).each do |game|
      playtime = game['playtime_forever'] / 60
      expect(user.purchases.pluck(:playtime)).to include playtime
    end
  end

  it 'updates purchase playtimes' do
    AddOwnedGamesService.new(user).call
    purchase = user.purchases.last
    correct_playtime = purchase.playtime

    purchase.playtime = 0
    AddOwnedGamesService.new(user).call
    expect(user.purchases.last.playtime).to eq correct_playtime
  end
end