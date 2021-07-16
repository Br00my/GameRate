FactoryBot.define do
  factory :comment do
    author { create(:user) }
    review
    text { "True" }
  end
end
