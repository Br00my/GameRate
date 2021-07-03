class Review < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :game

  validates :text, :rate, :multiplier, presence: true
end
