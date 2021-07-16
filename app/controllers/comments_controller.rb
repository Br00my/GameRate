class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :set_review, only: %i[create]

  def create
    unless current_user.owns?(@review.game)
      flash.now[:alert] = 'You should own the game'
      return
    end

    @comment = Comment.new(comment_params.merge({ review: @review, author: current_user }))

    if @comment.save
      flash.now[:notice] = 'Your comment was successfully published.'
    else
      flash.now[:alert] = 'Your comment was not published. Text can not be empty.'
    end
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
