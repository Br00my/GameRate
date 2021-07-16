class GamesUpdateJob < ApplicationJob
  queue_as :default

  def perform
    User.all.each do |user|
      AddOwnedGamesService.new(user).call
    end
  end
end
