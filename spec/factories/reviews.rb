FactoryBot.define do
  factory :review do
    author { create(:user) }
    game
    text { "Fun to play" }
    rate { 1 }
    multiplier { 1 }
  end
end
