require 'rails_helper'

RSpec.describe AddOwnedGamesService do
  let(:user) { create(:user) }
  it 'creates games' do
    expect { AddOwnedGamesService.new(user).call }.to change(Game, :count).by(1)
  end

  it 'creates purchase' do
    expect { AddOwnedGamesService.new(user).call }.to change(Purchase, :count).by(1)
  end
end