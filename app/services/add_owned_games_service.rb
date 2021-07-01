class AddOwnedGamesService
  def initialize(user)
    @user = user
  end

  def call
    games = SteamCov.owned_games(@user.id)
    return if games.nil?

    games.each do |game|
      game = SteamGameCov.new(game['appid'], game['name'], game['img_logo_url'], game['playtime_forever'])

      next unless game.success?

      new_game = Game.find_by(id: game.id) || Game.create!(id: game.id, title: game.title, picture: game.picture, genres: game.genres)
      Purchase.create!(user: @user, game: new_game, playtime: game.playtime)
    end
  end
end