class Review < ApplicationRecord
  MULTIPLIERS = { 0..10 => 1, 10..100 => 2, 100.. => 3}
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  belongs_to :game

  has_many :comments

  validates :text, :rate, :multiplier, presence: true

  before_validation :set_multiplier

  private

  def set_multiplier
    purchase = Purchase.find_by(owner: author, game: game)
    self.multiplier = MULTIPLIERS.select{ |range| range.cover? purchase.playtime }.values.first
  end
end
