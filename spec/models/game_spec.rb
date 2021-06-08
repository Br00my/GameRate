require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :picture }
  it { should validate_presence_of :genres }
end
