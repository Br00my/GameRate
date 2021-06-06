class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[steam]  

  validates :username, :uid, presence: true
end
