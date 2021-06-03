class User < ApplicationRecord
  devise :omniauthable, omniauth_providers: %i[steam]

  has_many :authorizations, dependent: :destroy

  validates :username,:email, presence: true
end
