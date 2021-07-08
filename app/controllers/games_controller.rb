class GamesController < ApplicationController
  before_action :set_game, only: %i[show]
  
  def index
    @games = Game.all
  end

  def update_list
    old_games = current_user.games.count
    AddOwnedGamesService.new(current_user).call
    new_games = [current_user.games.count - old_games, 0].max
    redirect_to root_path, notice: "#{new_games} new #{'game'.pluralize(new_games)} found."
  end

  def show
    @review = Review.new
    @reviews = @game.reviews
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
