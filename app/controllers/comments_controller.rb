class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy update]
  before_action :set_review, only: %i[create]
  before_action :set_comment, only: %i[destroy update]

  def create
    unless current_user.owns?(@review.game)
      flash.now[:alert] = 'You should own the game'
      return
    end

    @comment = Comment.new(comment_params.merge({ review: @review, author: current_user }))

    if @comment.save
      publish
      flash.now[:notice] = 'Your comment was successfully published.'
    else
      flash.now[:alert] = 'Your comment was not published. Text can not be empty.'
    end
  end

  def destroy
    unless current_user.comment_author?(@comment)
      flash.now[:alert] = 'Comment does not belong to you'
      return
    end

    @comment.destroy
    destroy_published
    flash.now[:notice] = 'Your comment was successfully deleted.'
  end

  def update
    unless current_user.comment_author?(@comment)
      flash.now[:alert] = 'Comment does not belong to you'
      return
    end

    if @comment.update(comment_params)
      update_published
      flash.now[:notice] = 'Your comment was successfully edited.'
    else
      flash.now[:alert] = 'Your comment was not edited. Text can not be blank.'
    end
  end

  private

  def destroy_published
    ActionCable.server.broadcast(
      'comments',
      action: :destroy,
      comment_id: @comment.id,
      user_id: current_user.id
      )
  end

  def update_published
    ActionCable.server.broadcast(
      'comments',
      action: :update,
      comment_id: @comment.id,
      comment_text: @comment.text,
      user_id: current_user.id
      )
  end

  def publish
    ActionCable.server.broadcast(
      'comments',
      action: :create,
      comment_id: @comment.id,
      comment_text: @comment.text,
      review_id: @comment.review.id,
      user_id: current_user.id
      )
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_review
    @review = Review.find(params[:review_id])
  end

  def comment_params
    params.require(:comment).permit(:text)
  end
end
