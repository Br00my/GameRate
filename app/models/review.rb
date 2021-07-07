class Review < ApplicationRecord
  MULTIPLIERS = { 0..10 => 1, 10..100 => 2, 100.. => 3}
  belongs_to :author, class_name: 'User', foreign_key: :user_id
  belongs_to :game

  validates :text, :rate, :multiplier, presence: true

  before_validation :set_multiplier
  after_create :set_game_rate

  private

  def set_multiplier
    purchase = Purchase.find_by(owner: author, game: game)
    self.multiplier = MULTIPLIERS.select{ |range| range.cover? purchase.playtime }.values.first
  end

  def set_game_rate
    if game.rate
      game_rate = ((rate * multiplier + game.rate)/(multiplier + 1)).round(1)
    else
      game_rate = rate
    end
    
    game.update!(rate: game_rate)
  end
end
