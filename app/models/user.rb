class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[steam]

  has_many :purchases
  has_many :games, through: :purchases
  has_many :reviews

  validates :username, presence: true

  def reviewed?(game)
    reviews.any?{ |review| review.game == game }
  end
end
