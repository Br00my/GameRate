class Game < ApplicationRecord
  validates :title, :picture, :genres, presence: true

  has_many :purchases
  has_many :owners, through: :purchases
  has_many :reviews

  def rate
    rate_sum = 0
    multiplier_sum = 0
    reviews.each do |review|
      rate_sum += review.rate * review.multiplier
      multiplier_sum += review.multiplier
    end
    (rate_sum.to_f / multiplier_sum).round(1)
  end
end
