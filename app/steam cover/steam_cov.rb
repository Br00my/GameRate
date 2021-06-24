class SteamCov
  INDEX_OF_ACCESS = 3

  class << self
    def profile_public?(user_id)
      Steam::User.summary(user_id)["communityvisibilitystate"] == INDEX_OF_ACCESS
    end

    def owned_games(user_id)
      Steam::Player.owned_games(user_id, params: { include_appinfo: true })["games"] || []
    end

    def game_details(game_id)
      Steam::Store.app_details(game_id)["#{game_id}"]
    end
  end
end