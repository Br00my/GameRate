class Purchase < ApplicationRecord
  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  belongs_to :game
end
