class SteamGameCov
  attr_reader :id, :title, :picture, :genres, :playtime

  def initialize(id, title, logo_url, playtime)
    @id = id
    @title = title
    @picture = "http://media.steampowered.com/steamcommunity/public/images/apps/#{id}/#{logo_url}.jpg"
    @playtime = playtime / 60

    details = SteamCov.game_details(id)
    if details['success']
      @genres = details["data"]["genres"].map{|x|x['description']}.join(', ') if details["data"]["genres"]
    end
  end

  def success?
    @genres && !@genres&.empty?
  end
end