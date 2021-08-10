class SearchesController < ApplicationController
  def games
    @searched_games = Game.search(conditions: { title: params[:title], genres: params[:genres] }, order: :rate, sort_mode: :desc)
  end
end
