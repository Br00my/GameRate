class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[steam]

  has_many :purchases
  has_many :games, through: :purchases
  has_many :reviews
  has_many :comments

  validates :username, presence: true

  def reviewed?(game)
    reviews.any?{ |review| review.game == game }
  end

  def owns?(game)
    games.include?(game)
  end

  def review_author?(review)
    review.author.id == id
  end

  def comment_author?(comment)
    comment.author.id == id
  end
end
