class SteamCover
  INDEX_OF_ACCESS = 3

  class << self
    def profile_public?(auth)
      Steam::User.summary(auth[:uid])["communityvisibilitystate"] == INDEX_OF_ACCESS
    end

    def owned_games(user)
      Steam::Player.owned_games(user.id, params: { include_appinfo: true })["games"]
    end

    def game_details(game_id)
      Steam::Store.app_details(game_id)["#{game_id}"]
    end
  end
end