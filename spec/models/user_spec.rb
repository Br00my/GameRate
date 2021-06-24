require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :username }
  it { should have_many :purchases }
  it { should have_many(:games) }
end
