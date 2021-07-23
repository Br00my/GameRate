class ReviewsChannel < ApplicationCable::Channel
  def follow
    stream_from "reviews"
  end
end