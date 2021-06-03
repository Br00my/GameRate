FactoryBot.define do
  sequence :username do |n|
    "username#{n}"
  end

  sequence :email do |n|
    "email#{n}@mail.ru"
  end

  factory :user do
    username
    email
  end
end
