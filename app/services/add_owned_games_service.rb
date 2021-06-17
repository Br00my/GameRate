class AddOwnedGamesService
  def initialize(user)
    @user = user
  end

  def call
    games = SteamCover.owned_games(@user)
    return if games.nil?

    games.each do |game|
      game_id = game['appid']
      game_details = SteamCover.game_details(game_id)
      game_title = game['name']

      next if !game_details['success']
      
      game_picture = "http://media.steampowered.com/steamcommunity/public/images/apps/#{game_id}/#{game['img_logo_url']}.jpg"
      if game_details["data"]["genres"]
        game_genres = game_details["data"]["genres"].map{|x|x['description']}.join(', ')
      end

      playtime = game['playtime_forever'] / 60

      new_game = Game.find_by(id: game_id)

      new_game = Game.create!(id: game_id, title: game_title, picture: game_picture, genres: game_genres) unless new_game
      Purchase.create!(user: @user, game: new_game, playtime: playtime)
    end
  end
end