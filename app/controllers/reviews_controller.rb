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
      set_game_stars_partial
      publish
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
      set_game_stars_partial
      update_published
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
    set_game_stars_partial
    destroy_published
    flash.now[:notice] = 'Your review was successfully deleted.'
  end

  private

  def set_game_stars_partial
    @game_stars_partial = render_to_string(partial: 'games/stars', locals: { game_rate: @review.game.rate })
  end

  def update_published
    ActionCable.server.broadcast(
      'reviews',
      action: :update,
      review_partial: render_to_string(partial: 'reviews/data', locals: { review: @review }),
      review_id: @review.id,
      game_stars_partial: @game_stars_partial,
      game_id: @review.game.id,
      user_id: current_user.id
      )
  end
  
  def destroy_published
    ActionCable.server.broadcast(
      'reviews',
      action: :destroy,
      review_id: @review.id,
      game_stars_partial: @game_stars_partial,
      game_id: @review.game.id,
      user_id: current_user.id
      )
  end

  def publish
    ActionCable.server.broadcast(
      'reviews',
      action: :create,
      review_partial: render_to_string(partial: 'reviews/data', locals: { review: @review }),
      review_id: @review.id,
      game_stars_partial: @game_stars_partial,
      game_id: @review.game.id,
      comment_create_window_partial: render_to_string(partial: 'comments/create_window', locals: { review: @review }),
      user_id: current_user.id
      )
  end

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
