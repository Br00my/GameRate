class Game < ApplicationRecord
  validates :title, :picture, :genres, presence: true

  has_and_belongs_to_many :players, class_name: 'User', join_table: :purchases
end
