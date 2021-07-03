require 'rails_helper'

RSpec.describe Review, type: :model do
  it { should belong_to :author }
  it { should belong_to :game }

  it { should validate_presence_of :text }
  it { should validate_presence_of :rate }
  it { should validate_presence_of :multiplier }
end
