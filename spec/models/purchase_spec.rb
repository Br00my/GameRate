require 'rails_helper'

RSpec.describe Purchase, type: :model do
  it { should belong_to :owner }
  it { should belong_to :game }
end
