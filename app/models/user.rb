class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[steam]

  has_many :purchases
  has_many :games, through: :purchases
  has_many :reviews

  validates :username, presence: true
end
