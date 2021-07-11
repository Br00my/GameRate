require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :author }
  it { should belong_to :review }

  it { should validate_presence_of :text }
end
