class Review < ApplicationRecord
  MULTIPLIERS = { 0..10 => 1, 10..100 => 2, 100.. => 3}
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  belongs_to :game

  has_many :comments, dependent: :destroy

  validates :text, :rate, :multiplier, presence: true
  validates :rate, length: { in: 1..5 }
  validate :one_reviewer, on: :create

  before_validation :set_multiplier, on: :create

  private

  def set_multiplier
    purchase = Purchase.find_by(owner: author, game: game)
    self.multiplier = MULTIPLIERS.select{ |range| range.cover? purchase.playtime }.values.first
  end

  def one_reviewer
    if game.reviews.exists?(user_id: author.id)
      errors.add('User can have only one review to each game')
    end
  end
end
