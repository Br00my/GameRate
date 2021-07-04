class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :set_game

  def create
    @review = Review.new(review_params.merge({ game: @game, author: current_user }))

    if @review.save
      flash.now[:notice] = 'Your review was successfully published.'
    else
      flash.now[:alert] = 'Your review was not published. Both star rate and text are needed.'
    end
  end

  private

  def review_params
    params.require(:review).permit(:text, :rate)
  end

  def set_game
    @game = Game.find(params[:game_id])
  end
end
