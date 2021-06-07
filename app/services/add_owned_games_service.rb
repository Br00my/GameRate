class AddOwnedGamesService
  def initialize(user)
    @user = user
  end

  def call
    games = Steam::Player.owned_games(@user.id, params: { include_appinfo: 1 })["games"]
    games.each do |game|
      game_id = game['appid']
      game_title = game['name']
      picture = "http://media.steampowered.com/steamcommunity/public/images/apps/#{game_id}/#{game['img']}.jpg"
      genres = JSON.load(open("https://store.steampowered.com/api/appdetails?appids=#{game_id}"))["#{game_id}"]["data"]["genres"].map{|x|x['description']}.join(', ')
      # Game.create(id: game_id, game_)
    end
  end
end