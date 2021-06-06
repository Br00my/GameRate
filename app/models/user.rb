class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[steam]  

  validates :username, :uid, :key, presence: true
end
