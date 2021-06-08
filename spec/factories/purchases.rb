FactoryBot.define do
  factory :purchase do
  it { should belong_to :user }    
  it { should belong_to :game }    
  end
end
