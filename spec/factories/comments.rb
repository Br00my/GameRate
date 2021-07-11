FactoryBot.define do
  factory :comment do
    author { create(:user) }
    review
    text { "MyString" }
  end
end
