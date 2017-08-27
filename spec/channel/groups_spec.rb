require 'spec_helper'

describe 'Yt::Channel#groups', :account do
  subject(:channel) { $own_channel }

  it 'returns the list of groups of the channel' do
    expect(channel.groups).to all( be_a Yt::Group )
  end
end

