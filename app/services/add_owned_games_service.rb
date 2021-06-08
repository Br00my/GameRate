class AddOwnedGamesService
  def initialize(user)
    @user = user
  end

  def call
    games = Steam::Player.owned_games(@user.id, params: { include_appinfo: 1 })["games"]

    return unless games

    games.each do |game|
      game_id = game['appid']
      game_details = Steam::Store.app_details(game_id)["#{game_id}"]
      next unless game_details['success']

      game_title = game['name']
      game_picture = "http://media.steampowered.com/steamcommunity/public/images/apps/#{game_id}/#{game['img_logo_url']}.jpg"
      game_genres = game_details["data"]["genres"].map{|x|x['description']}.join(', ')
      
      playtime = game['playtime_forever'] / 60

      new_game = Game.find_by(id: game_id)

      new_game = Game.create(id: game_id, title: game_title, picture: game_picture, genres: game_genres) unless new_game
      Purchase.create(user: @user, game: new_game, playtime: playtime)
    end
  end
end