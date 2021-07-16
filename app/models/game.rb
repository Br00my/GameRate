class Game < ApplicationRecord
  validates :title, :picture, :genres, presence: true

  has_many :purchases
  has_many :owners, through: :purchases
  has_many :reviews, dependent: :destroy

  def rate
    (reviews.sum('multiplier * rate').to_f / reviews.sum(:multiplier)).round(1)
  end
end
