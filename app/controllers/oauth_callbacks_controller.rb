class OauthCallbacksController < Devise::OmniauthCallbacksController
  skip_forgery_protection with: :null_session
  def steam
    @user = User.find_by(id: auth[:uid])

    unless @user&.persisted?
      @user = User.create(id: auth[:uid], username: auth[:info][:nickname])
    end
    
    if Steam::User.summary(current_user.id)["communityvisibilitystate"] == 3
      games = Steam::Player.owned_games(current_user.id, params: { include_appinfo: 1 })["games"]
      games.each do |game|
        game_id = game['appid']
        game_title = game['name']
        picture = "http://media.steampowered.com/steamcommunity/public/images/apps/#{game_id}/#{game['img']}.jpg"
        genres = JSON.load(open("https://store.steampowered.com/api/appdetails?appids=#{game_id}"))["#{game_id}"]["data"]["genres"].map{|x|x['description']}.join(', ')
        # Game.create(id: game_id, game_)
      end

      flash[:notice] += 'Here are the games we found in your profile'
    else
      flash[:alert] += 'Your Steam profile is private. Make it public so we can list your purchased games'
    end

    sign_in_and_redirect @user
    set_flash_message(:notice, :success, username: auth[:info][:nickname]) if is_navigational_format?
  end

  private

  def auth
    request.env['omniauth.auth']
  end
end