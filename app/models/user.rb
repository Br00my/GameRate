class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[steam]

  has_many :purchases
  has_many :games, as: :player, class_name: 'Game', through: :purchases

  validates :username, presence: true
end
