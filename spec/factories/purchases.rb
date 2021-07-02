FactoryBot.define do
  factory :purchase do
    user
    game
    playtime { 10 }
  end
end
