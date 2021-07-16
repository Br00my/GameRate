class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :set_game, only: %i[create]
  before_action :set_review, only: %i[update destroy]

  def create
    if current_user.reviewed?(@game) || !current_user.owns?(@game)
      flash.now[:alert] = 'You have already reviewed the game or do not own it'
      return
    end

    @review = Review.new(review_params.merge({ game: @game, author: current_user }))

    if @review.save
      flash.now[:notice] = 'Your review was successfully published.'
    else
      flash.now[:alert] = 'Your review was not published. Both star rate and text are needed.'
    end
  end

  def update
    unless current_user.review_author?(@review)
      flash.now[:alert] = 'Review does not belong to you'
      return
    end

    if @review.update(review_params)
      flash.now[:notice] = 'Your review was successfully edited.'
    else
      flash.now[:alert] = 'Your review was not edited. Both star rate and text are needed.'
    end
  end

  def destroy
    unless current_user.review_author?(@review)
      flash.now[:alert] = 'Review does not belong to you'
      return
    end

    @review.destroy
    flash.now[:notice] = 'Your review was successfully deleted.'
  end

  private

  def review_params
    params.require(:review).permit(:text, :rate)
  end

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end
end
