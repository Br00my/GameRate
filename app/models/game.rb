class Game < ApplicationRecord
  validates :title, :picture, presence: true

  has_many :purchases
  has_many :players, class_name: 'User', through: :purchases
end
