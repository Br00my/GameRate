class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[steam]  

  has_and_belongs_to_many :games, as: :player, class_name: 'Game', join_table: :purchases

  validates :username, presence: true
end
