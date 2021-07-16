FactoryBot.define do
  factory :purchase do
    owner { create(:user) }
    game
    playtime { 10 }
  end
end
