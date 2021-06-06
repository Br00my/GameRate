FactoryBot.define do
  factory :user do
    username { 'tester' }
    uid { '1234' }
    key { Rails.application.credentials[Rails.env.to_sym][:steam][:key] }
  end
end
