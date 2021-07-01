class Game < ApplicationRecord
  validates :title, :picture, :genres, presence: true

  has_many :purchases
  has_many :players, through: :purchases, source: :user
end
