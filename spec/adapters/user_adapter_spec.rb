require 'spec_helper'

RSpec.describe ZohoCrm::Adapters::User do
  it 'parses get users response' do
    type = 'AllUsers'

    adapter = described_class.new

    allow(adapter).to receive(:get_users_url).with('Users', type: type) { 'get-users-url' }
    allow(adapter).to receive(:perform_get) { JSON.parse(fixture('get-users.json')) }

    results = adapter.get_users(type)

    expect(results.size).to be(1)
    expect(results.map { |result| result['id'] }).to eq(['1'])
  end
end
