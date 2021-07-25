class GamesController < ApplicationController
  before_action :authenticate_user!, only: %i[update_list]
  before_action :set_game, only: %i[show]
  
  def index
    @games = Game.all.order('rate DESC')
  end

  def update_list
    old_games = current_user.games.count
    AddOwnedGamesService.new(current_user).call
    new_games = [current_user.games.count - old_games, 0].max
    redirect_to root_path, notice: "#{new_games} new #{'game'.pluralize(new_games)} found."
  end

  def show
    @reviews = @game.reviews
    gon.owns_game = current_user&.owns?(@game)
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
