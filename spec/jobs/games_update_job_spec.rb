require 'rails_helper'

RSpec.describe GamesUpdateJob, type: :job do
  let(:service) { double('AddOwnedGamesService') }
  let!(:user){ create(:user) }

  it 'adds new games to user' do
    expect(AddOwnedGamesService).to receive(:new).with(user).and_return(service)
    expect(service).to receive :call
    GamesUpdateJob.perform_now
  end
end
